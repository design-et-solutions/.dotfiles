# Nix
Nix is a tool for people who both need computers to do exactly as intended, repeatably, far into the future.
+ Reproducible development environments.
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

## Nix CLI Tools
+ `nix-shell` build the dependencies of the specified derivation, but not the derivation itself.
  
  > ```
  > $ nix-shell -p git --run "git --version" --pure -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/2a601aafdc5605a5133a2ca506a34a3a73377247.tar.gz
  > ...
  > git version 2.33.1
  > ```
+ `nix repl` to evaluate Nix expressions interactively.

  > ```shell
  > $ nix repl
  > Welcome to Nix 2.13.3. Type :? for help.
  > 
  > nix-repl> 1 + 2
  > 3
  > ```
+ `nix-instantiate --eval` to evaluate the expression in a Nix file.

  > ```shell
  > $ echo 1 + 2 > file.nix
  > $ nix-instantiate --eval file.nix
  > 3
  > ```

## Reproducible interpreted scripts
Create a file called `nixpkgs-releases.sh` with these contents:
```shell
#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure
#! nix-shell -p bash cacert curl jq python3Packages.xmljson
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/2a601aafdc5605a5133a2ca506a34a3a73377247.tar.gz

curl https://github.com/NixOS/nixpkgs/releases.atom | xml2json | jq .
```
Make the script executable:
```shell
chmod +x nixpkgs-releases.sh
```
Run the script:
```shell
./nixpkgs-releases.sh
```

## Declarative shell environments
Create a file called `shell.nix` with these contents:
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
Enter the environment by running `nix-shell` in the same directory as `shell.nix`:
```shell
nix-shell
[nix-shell]$ cowsay hello | lolcat
[nix-shell]$ echo $GREETING
```

## Pinning Nixpkgs
Create fully reproducible Nix expressions, we can pin an exact version of Nixpkgs:
```nix
{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/06278c77b5d162e62df170fec307e83f1812d94b.tar.gz") {}
}:

...
```
