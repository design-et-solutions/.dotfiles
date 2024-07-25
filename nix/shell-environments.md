# Declarative shell environments
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
