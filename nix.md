# Nix
Nix is a tool for people who both need computers to do exactly as intended, repeatably, far into the future.
+ Reproducible development environments. ([see](#nix-shell-environment))
+ Easy installation of software over URLs.
+ Easy transfer of software environments between computers.
+ Declarative specification of Linux machines.
+ Reproducible integration testing using virtual machines.
+ Avoidance of version conflicts with already installed software.
+ Installing software from source code.
+ Transparent build caching using binary caches.
+ Strong support for software auditability.
+ First-class cross compilation support.
+ Remote builds.
+ Remote deployments.
+ Atomic upgrades and rollbacks.

## Nix shell environment
The command nix-shell will build the dependencies of the specified derivation, but not the derivation itself.\
Use any program packaged with Nix, without installing it permanently.

> [!TIP]
> See [nix-shell]([https://search.nixos.org/packages](https://nix.dev/manual/nix/2.18/command-ref/nix-shell)) to manual.

Share the command invoking such a shell with others (work on all Linux distributions, WSL, and macOS).\
Like this:
```shell
nix-shell -p git --run "git --version" --pure -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/2a601aafdc5605a5133a2ca506a34a3a73377247.tar.gz
...
git version 2.33.1
```
+ `--run` executes the given **Shell** command within the **Nix shell** and exits when it’s done. You can use this with nix-shell whenever you want to quickly run a program you don’t have installed on your machine.
+ `--pure` discards most environment variables set on your system when running the **Shell**. Use it only when the extra isolation is needed.
+ `-I` determines what to use as a source of package declarations. Leaving no doubt about which version of the packages in that collection will be used.

## Reproducible interpreted scripts
Using Nix to create and run reproducible interpreted scripts, also known as shebang scripts.\
Like this:
```shell
#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure
#! nix-shell -p bash cacert curl jq python3Packages.xmljson
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/2a601aafdc5605a5133a2ca506a34a3a73377247.tar.gz

curl https://github.com/NixOS/nixpkgs/releases.atom | xml2json | jq .
```
+ The additional shebang lines are a Nix-specific construct.
+ Specify bash as the interpreter for the rest of the file with the `-i` option.
+ Enable the `--pure` option to prevent the script from implicitly using programs that may already exist on the system that will run the script.
+ With the `-p` option we specify the packages required for the script to run.
+ The command `xml2json` is provided by the package `python3Packages.xmljson`, while `bash`, `jq`, and `curl` are provided by packages of the same name. `cacert` must be present for SSL authentication to work.
+ The parameter of `-I` refers to a specific Git commit of the Nixpkgs repository.

> [!TIP]
> Use [search.nixos.org](https://search.nixos.org/packages) to find packages providing the program you need.

Make the script executable:
```shell
chmod +x nixpkgs-releases.sh
```
Run the script:
```shell
./nixpkgs-releases.sh
```

## Declarative shell environments
Declarative shell environments allow you to:
+ Automatically run bash commands during environment activation
+ Automatically set environment variables
+ Put the environment definition under version control and reproduce it on other machines

Create reproducible shell environments with a declarative configuration in a Nix file.\
This file can be shared with anyone to recreate the same environment on a different machine.\
Create a file called shell.nix with these contents:
```nix
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShellNoCC {
  packages = with pkgs; [
    cowsay
    lolcat
  ];

  GREETING = "Hello, Nix!";

  shellHook = ''
    echo $GREETING | cowsay | lolcat
  '';
}
```
+ We use a version of Nixpkgs pinned to a release branch, and explicitly set configuration options and overlays to avoid them being inadvertently overridden by global configuration.
+ `mkShellNoCC` is a function that produces such an environment, but without a compiler toolchain. `mkShellNoCC` takes as argument an attribute set. Here we give it an attribute packages with a list containing one item from the pkgs attribute set.
+ Set `GREETING` so it can be used in the shell environment. Any attribute name passed to `mkShellNoCC` that is not reserved otherwise and has a value which can be coerced to a string will end up as an environment variable.
+ To run command `echo $GREETING | cowsay | lolcat` before entering the shell environment. This command can be placed in the `shellHook` attribute provided to `mkShellNoCC`.

> [!WARNING]
> Some variables are protected from being set as described above.
> If you need to override these protected environment variables, use the `shellHook` attribute

> [!TIP]
> See [mkShell](https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-mkShell) to manual.\
> See [Shell functions and utilities](https://nixos.org/manual/nixpkgs/stable/#ssec-stdenv-functions).

Enter the environment by running nix-shell in the same directory as shell.nix.
```shell
nix-shell
[nix-shell]$ cowsay hello | lolcat
[nix-shell]$ echo $GREETING
```
`nix-shell` by default looks for a file called `shell.nix` in the current directory and builds a shell environment from the Nix expression in this file.\
Packages defined in the packages attribute will be available in `$PATH`.
