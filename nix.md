# Nix
Nix is a tool for people who both need computers to do exactly as intended, repeatably, far into the future.
+ Reproducible development environments. ([see](#nix-shell-environment))
+ Easy installation of software over URLs.
+ Easy transfer of software environments between computers.
+ Declarative specification of Linux machines. ([see](#declarative-shell-environments))
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

## Pinning Nixpkgs
In various Nix examples, you’ll often see references to `<nixpkgs>`, as follows.
```nix
{ pkgs ? import <nixpkgs> {} }:

...
```
This is a convenient way to quickly demonstrate a Nix expression and get it working by importing Nix packages.\
However, the resulting Nix expression is not fully reproducible.\
Create fully reproducible Nix expressions, we can pin an exact version of Nixpkgs.\
The simplest way to do this is to fetch the required Nixpkgs version as a tarball specified via the relevant Git commit hash:
```nix
{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/06278c77b5d162e62df170fec307e83f1812d94b.tar.gz") {}
}:

...
```

> [!TIP]
> Picking the commit can be done via [status.nixos.org](https://status.nixos.org/), which lists all the releases and the latest commit that has passed all tests.

When choosing a commit, it is recommended to follow either:
+ The latest stable NixOS release by using a specific version.
+ The latest unstable release via nixos-unstable.

## Interactive evaluation
Use `nix repl` to evaluate Nix expressions interactively:
```shell
$ nix repl
Welcome to Nix 2.13.3. Type :? for help.

nix-repl> 1 + 2
3
```
> [!NOTE]
> Some examples show a fully evaluated data structure for clarity.\
> If your output does not match the example, try prepending `:p` to the input expression.
> ```shell
> { a.b.c = 1; }
>
> :p { a.b.c = 1; }
> ```
> Type `:q` to exit nix repl.

## Evaluating Nix files
Use `nix-instantiate --eval` to evaluate the expression in a Nix file.
```shell
$ echo 1 + 2 > file.nix
$ nix-instantiate --eval file.nix
3
```
+ `--eval` is required to evaluate the file and do nothing else. If `--eval` is omitted, `nix-instantiate` expects the expression in the given file to evaluate to a special value called a derivation.

`nix-instantiate --eval` will try to read from `default.nix` if no file name is specified.\
The Nix language uses lazy evaluation, and `nix-instantiate` by default only computes values when needed.\
Try adding the `--strict` option to `nix-instantiate` to  have an explicit value\
Like this:
```shell
$ echo "{ a.b.c = 1; }" > file.nix
$ nix-instantiate --eval file.nix
{ a = <CODE>; }

$ echo "{ a.b.c = 1; }" > file.nix
$ nix-instantiate --eval --strict file.nix
{ a = { b = { c = 1; }; }; }
```

## NixOS configuration
```nix
{ config, pkgs, ... }: {

  imports = [ ./hardware-configuration.nix ];

  environment.systemPackages = with pkgs; [ git ];

  # ...

}
```
Explanation:
+ This expression is a function that takes an attribute set as an argument.
  It returns an attribute set.
+ The argument must at least have the attributes `config` and `pkgs`, and may have more attributes.
+ The returned attribute set contains the attributes `imports` and `environment`.
+ `imports` is a list with one element called `hardware-configuration.nix`.
+ `environment` is itself an attribute set with one attribute `systemPackages`, which will evaluate to a list with one element: the `git` attribute from the `pkgs` set.
+ The `config` argument is not (shown to be) used.

## Package
```nix
{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {

  pname = "hello";

  version = "2.12";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1ayhp9v4m4rdhjmnl2bq3cibrbqqkgjbl3s7yk2nhlh8vj3ay16g";
  };

  meta = with lib; {
    license = licenses.gpl3Plus;
  };

}
```
Explanation:
+ This expression is a function that takes an attribute set which must have exactly the attributes `lib`, `stdenv`, and `fetchurl`.
+ It returns the result of evaluating the function `mkDerivation`, which is an attribute of `stdenv`, applied to a recursive set.
+ The recursive set passed to `mkDerivation` uses its own `pname` and `version` attributes in the argument to the function `fetchurl`.
  `fetchurl` itself comes from the outer function’s arguments.
+ The `meta` attribute is itself an attribute set, where the license attribute has the value that was assigned to the nested attribute `lib.licenses.gpl3Plus`.
