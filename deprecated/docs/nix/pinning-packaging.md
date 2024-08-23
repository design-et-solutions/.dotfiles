# Pinning Nixpkgs
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
