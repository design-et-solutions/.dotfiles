# Recipes

## Configure Nix to use a custom binary cache
Nix can be configured to use a binary cache with the `substituters` and `trusted-public-keys` settings, either exclusively or in addition to [cache.nixos.org](https://cache.nixos.org/).

For example, given a binary cache at `https://example.org` with public key `My56...Q==%`, and some derivation in `default.nix`, make Nix exclusively use that cache once by passing settings as command line flags:
```shell
$ nix-build --substituters https://example.org --trusted-public-keys example.org:My56...Q==%
```
To permanently use the custom cache in addition to the public cache, add to the Nix configuration file:
```shell
$ echo "extra-substituters = https://example.org" >> /etc/nix/nix.conf
$ echo "extra-trusted-public-keys = example.org:My56...Q==%" >> /etc/nix/nix.conf
```
To always use only the custom cache:
```shell
$ echo "substituters = https://example.org" >> /etc/nix/nix.conf
$ echo "trusted-public-keys = example.org:My56...Q==%" >> /etc/nix/nix.conf
```

> [!NOTE]
> On NixOS, Nix is configured through the `nix.settings` option:
> ```nix
> { ... }: {
>   nix.settings = {
>     substituters = [ "https://example.org" ];
>     trusted-public-keys = [ "example.org:My56...Q==%" ];
>   };
> }
> ```

## Automatic environment activation with `direnv`
Instead of manually activating the environment for each project, you can reload a declarative shell every time you enter the project’s directory or change the `shell.nix` inside it.\
For example, write a shell.nix with the following contents:
```nix
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShellNoCC {
  packages = with pkgs; [
    hello
  ];
}
```
From the top-level directory of your project run:
```shell
$ echo "use nix" > .envrc && direnv allow
```
The next time you launch your terminal and enter the top-level directory of your project, [`direnv`](https://github.com/nix-community/nix-direnv) will automatically launch the shell defined in `shell.nix`.
```shell
$ cd myproject
$ which hello
/nix/store/1gxz5nfzfnhyxjdyzi04r86sh61y4i00-hello-2.12.1/bin/hello
```
`direnv` will also check for changes to the `shell.nix` file.\
Make the following addition:
```nix
 let
   nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
   pkgs = import nixpkgs { config = {}; overlays = []; };
 in

 pkgs.mkShellNoCC {
   packages = with pkgs; [
     hello
   ];
+
+  shellHook = ''
+    hello
+  '';
 }
```
The running environment should reload itself after the first interaction (run any command or press `Enter`).
```shell
Hello, world!
```

## Dependencies in the development shell
When packaging software in `default.nix`, you’ll want a development environment in `shell.nix` to enter it conveniently with `nix-shell` or automatically with `direnv`.\
How to share the package’s dependencies in default.nix with the development environment in shell.nix?

Use the `inputsFrom` attribute to `pkgs.mkShellNoCC`:
```nix
# default.nix
let
  pkgs = import <nixpkgs> {};
  build = pkgs.callPackage ./build.nix {};
in
{
  inherit build;
  shell = pkgs.mkShellNoCC {
    inputsFrom = [ build ];
  };
}
```
Import the shell attribute in `shell.nix`:
```nix
# shell.nix
(import ./.).shell
```
Assume your build is defined in `build.nix`:
```nix
# build.nix
{ cowsay, runCommand }:
runCommand "cowsay-output" { buildInputs = [ cowsay ]; } ''
  cowsay Hello, Nix! > $out
''
```
In this example, `cowsay` is declared as a build-time dependency using `buildInputs`.\
Further assume your project is defined in `default.nix`:
```nix
# default.nix
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in
{
  build = pkgs.callPackage ./build.nix {};
}
```
Add an attribute to `default.nix` specifying an environment:
```nix
 let
   nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
   pkgs = import nixpkgs { config = {}; overlays = []; };
 in
 {
   build = pkgs.callPackage ./build.nix {};
+  shell = pkgs.mkShellNoCC {
+  };
 }
```
Move the `build` attribute into the `let` binding to be able to re-use it.\
Then take the package’s dependencies into the environment with `inputsFrom`:
```nix
 let
   nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
   pkgs = import nixpkgs { config = {}; overlays = []; };
+  build = pkgs.callPackage ./build.nix {};
 in
 {
-  build = pkgs.callPackage ./build.nix {};
+  inherit build;
   shell = pkgs.mkShellNoCC {
+    inputsFrom = [ build ];
   };
 }
```
Finally, import the `shell` attribute in `shell.nix`:
```nix
# shell.nix
(import ./.).shell
```
Check the development environment, it contains the build-time dependency `cowsay`:
```shell
$ nix-shell --pure
[nix-shell]$ cowsay shell.nix
```

## Automatically managing remote sources with `npins`
The Nix language can be used to describe dependencies between files managed by Nix.\
Nix expressions themselves can depend on remote sources, and there are multiple ways to specify their origin, as shown in Towards reproducibility: pinning Nixpkgs.\
For more automation around handling remote sources, set up `npins` in your project:
```shell
$ nix-shell -p npins --run "npins init --bare; npins add github nixos nixpkgs --branch nixos-23.11"
```
This command will fetch the latest revision of the Nixpkgs 23.11 release branch.\
In the current directory it will generate `npins/sources.json`, which will contain a pinned reference to the obtained revision.\
It will also create `npins/default.nix`, which exposes those dependencies as an attribute set.\
Import the generated `npins/default.nix` as the default value for the argument to the function in `default.nix` and use it to refer to the Nixpkgs source directory:
```nix
{
  sources ? import ./npins,
  system ? builtins.currentSystem,
  pkgs ? import sources.nixpkgs { inherit system; config = {}; overlays = []; },
}:
{
  package = pkgs.hello;
}
```
`nix-build` will call the top-level function with the empty attribute set `{}`, or with the attributes passed via `--arg` or `--argstr`.\
This pattern allows overriding remote sources programmatically.\
Add `npins` to the development environment for your project to have it readily available:
```nix
 {
   sources ? import ./npins,
   system ? builtins.currentSystem,
   pkgs ? import sources.nixpkgs { inherit system; config = {}; overlays = []; },
 }:
-{
+rec {
   package = pkgs.hello;
+  shell = pkgs.mkShellNoCC {
+    inputsFrom = [ package ];
+    packages = with pkgs; [
+      npins
+    ];
+  };
 }
 ```
 Also add a `shell.nix` to enter that environment more conveniently:
```nix
(import ./. {}).shell
```

Enter the development environment, create a new directory, and set up npins with a different version of Nixpkgs:
```shell
$ nix-shell
[nix-shell]$ mkdir old
[nix-shell]$ cd old
[nix-shell]$ npins init --bare
[nix-shell]$ npins add github nixos nixpkgs --branch nixos-21.11
```
Create a file `default.nix` in the new directory, and import the original one with the `sources` just created.
```nix
import ../default.nix { sources = import ./npins; }
```
This will result in a different version being built:
```shell
$ nix-build -A build
$ ./result/bin/hello --version | head -1
hello (GNU Hello) 2.10
```
Sources can also be overridden on the command line:
```shell
$ nix-build .. -A build --arg sources 'import ./npins'
```

## Setting up a Python development environment
In this example you will build a Python web application using the Flask web framework as an exercise.\
To make best use of it you should be familiar with defining declarative shell environments.\
Create a new file called `myapp.py` and add the following code:
```py
#!/usr/bin/env python

from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return {
        "message": "Hello, Nix!"
    }

def run():
    app.run(host="0.0.0.0", port=5000)

if __name__ == "__main__":
    run()
```
Create a new file `shell.nix` to declare the development environment:
```nix
{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11") {} }:

pkgs.mkShellNoCC {
  packages = with pkgs; [
    (python3.withPackages (ps: [ ps.flask ]))
    curl
    jq
  ];
}
```
This describes a shell environment with an instance of `python3` that includes the `flask` package using `python3.withPackages`.\
It also contains `curl`, a utility to perform web requests, and `jq`, a tool to parse and format JSON documents.\
Both of them are not Python packages.\
If you went with Python’s virtualenv, it would not be possible to add these utilities to the development environment without additional manual steps.\
Run nix-shell to enter the environment you just declared:
```shell
$ nix-shell
these 2 derivations will be built:
  /nix/store/5yvz7zf8yzck6r9z4f1br9sh71vqkimk-builder.pl.drv
  /nix/store/aihgjkf856dbpjjqalgrdmxyyd8a5j2m-python3-3.9.13-env.drv
these 93 paths will be fetched (109.50 MiB download, 468.52 MiB unpacked):
  /nix/store/0xxjx37fcy2nl3yz6igmv4mag2a7giq6-glibc-2.33-123
  /nix/store/138azk9hs5a2yp3zzx6iy1vdwi9q26wv-hook
...

[nix-shell]$ 
```
Start the web application within this shell environment:
```shell
[nix-shell]$ python ./myapp.py
 * Serving Flask app 'myapp'
 * Debug mode: off
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:5000
 * Running on http://192.168.1.100:5000
Press CTRL+C to quit
```

## Setting up post-build hooks
This guide shows how to use the Nix [`post-build-hook`](https://nix.dev/manual/nix/2.22/command-ref/conf-file#conf-post-build-hook) configuration option to automatically upload build results to an S3-compatible binary cache.

The post-build hook program runs after each executed build, and blocks the build loop.\
The build loop exits if the hook program fails.\
Concretely, this implementation will make Nix slow or unusable when the network connection is slow or unreliable.\
A more advanced implementation might pass the store paths to a user-supplied daemon or queue for processing the store paths outside of the build loop.

Use `nix-store --generate-binary-cache-key` to create a pair of cryptographic keys.\
You will sign paths with the private key, and distribute the public key for verifying the authenticity of the paths.
```shell
$ nix-store --generate-binary-cache-key example-nix-cache-1 /etc/nix/key.private /etc/nix/key.public
$ cat /etc/nix/key.public
example-nix-cache-1:1/cKDz3QCCOmwcztD2eV6Coggp6rqc9DGjWv7C0G+rM=
```
[Configure Nix to use a custom binary cache](https://nix.dev/guides/recipes/add-binary-cache#custom-binary-cache) on any machine that will access the bucket.\
For example, add the cache URL to `substituters` and the public key to `trusted-public-keys` in `nix.conf`:
```conf
substituters = https://cache.nixos.org/ s3://example-nix-cache
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= example-nix-cache-1:1/cKDz3QCCOmwcztD2eV6Coggp6rqc9DGjWv7C0G+rM=
```
Machines that build for the cache must sign derivations using the private key.\
The path to the file containing the private key you just generated must be added to the `secret-key-files` setting for those machines:
```conf
secret-key-files = /etc/nix/key.private
```

Write the following script to `/etc/nix/upload-to-cache.sh`:
```sh
#!/bin/sh
set -eu
set -f # disable globbing
export IFS=' '
echo "Uploading paths" $OUT_PATHS
exec nix copy --to "s3://example-nix-cache" $OUT_PATHS
```
The `$OUT_PATHS` variable is a space-separated list of Nix store paths.\
In this case, we expect and want the shell to perform word splitting to make each output path its own argument to `nix store sign`.\
Nix guarantees the paths will not contain any spaces, however a store path might contain glob characters.\
The `set -f` disables globbing in the shell.\
Make sure the hook program is executable by the root user:
```sh
$ chmod +x /etc/nix/upload-to-cache.sh
```
Set the `post-build-hook` configuration option on the local machine to run the hook:
```conf
post-build-hook = /etc/nix/upload-to-cache.sh
```
Then restart the `nix-daemon` an all involved machines, e.g. with
```sh
pkill nix-daemon
```
Build any derivation, for example:
```sh
$ nix-build -E '(import <nixpkgs> {}).writeText "example" (builtins.toString builtins.currentTime)'
this derivation will be built:
  /nix/store/s4pnfbkalzy5qz57qs6yybna8wylkig6-example.drv
building '/nix/store/s4pnfbkalzy5qz57qs6yybna8wylkig6-example.drv'...
running post-build-hook '/home/grahamc/projects/github.com/NixOS/nix/post-hook.sh'...
post-build-hook: Signing paths /nix/store/ibcyipq5gf91838ldx40mjsp0b8w9n18-example
post-build-hook: Uploading paths /nix/store/ibcyipq5gf91838ldx40mjsp0b8w9n18-example
/nix/store/ibcyipq5gf91838ldx40mjsp0b8w9n18-example
```
To check that the hook took effect, delete the path from the store, and try substituting it from the binary cache:
```sh
$ rm ./result
$ nix-store --delete /nix/store/ibcyipq5gf91838ldx40mjsp0b8w9n18-example
$ nix-store --realise /nix/store/ibcyipq5gf91838ldx40mjsp0b8w9n18-example
copying path '/nix/store/m8bmqwrch6l3h8s0k3d673xpmipcdpsa-example from 's3://example-nix-cache'...
warning: you did not specify '--add-root'; the result might be removed by the garbage collector
/nix/store/m8bmqwrch6l3h8s0k3d673xpmipcdpsa-example
```


