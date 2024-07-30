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


## Setting up a Python development environment


## Setting up post-build hooks

