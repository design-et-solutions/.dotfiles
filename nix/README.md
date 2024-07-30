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
+ `nix-instantiate` to evaluate the expression in a Nix file.

  > ```shell
  > $ echo 1 + 2 > file.nix
  > $ nix-instantiate --eval file.nix
  > 3
  > ```
+ `nix-build` to build nix package

  > ```shell
  > $ nix-build -A hello
  > this derivation will be built:
  >   /nix/store/rbq37s3r76rr77c7d8x8px7z04kw2mk7-hello.drv
  > building '/nix/store/rbq37s3r76rr77c7d8x8px7z04kw2mk7-hello.drv'...
  > ...
  > configuring
  > ...
  > configure: creating ./config.status
  > config.status: creating Makefile
  > ...
  > building
  > ... <many more lines omitted>
  > ```
+ `nix-prefetch-url`

  > ```shell
  > $ nix-prefetch-url --unpack https://github.com/atextor/icat/archive/refs/tags/v0.5.tar.gz --type sha256
  > path is '/nix/store/p8jl1jlqxcsc7ryiazbpm7c1mqb6848b-v0.5.tar.gz'
  > 0wyy2ksxp95vnh71ybj1bbmqd5ggp13x3mk37pzr99ljs9awy8ka
  > ```
+ `nix-locate` to quickly locate the package providing a certain file in nixpkgs.
  
  > ```shell
  > $ nix-locate 'bin/hello'
  > hello.out                                        29,488 x /nix/store/bdjyhh70npndlq3rzmggh4f2dzdsj4xy-hello-2.10/bin/hello
  > linuxPackages_4_4.dpdk.examples               2,022,224 x /nix/store/jlnk3d38zsk0bp02rp9skpqk4vjfijnn-dpdk-16.07.2-4.4.52-examples/bin/helloworld
  > linuxPackages.dpdk.examples                   2,022,224 x /nix/store/rzx4k0pb58gd1dr9kzwam3vk9r8bfyv1-dpdk-16.07.2-4.9.13-examples/bin/helloworld
  > linuxPackages_4_10.dpdk.examples              2,022,224 x /nix/store/wya1b0910qidfc9v3i6r9rnbnc9ykkwq-dpdk-16.07.2-4.10.1-examples/bin/helloworld
  > linuxPackages_grsec_nixos.dpdk.examples       2,022,224 x /nix/store/2wqv94290pa38aclld7sc548a7hnz35k-dpdk-16.07.2-4.9.13-examples/bin/helloworld
  > camlistore.out                                7,938,952 x /nix/store/xn5ivjdyslxldhm5cb4x0lfz48zf21rl-camlistore-0.9/bin/hello
  > ```
+ `nixos-generate-config` to create a configuration file that contains some useful defaults and configuration suggestions.
  
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

## Tree
```
nixos-config/
├── flake.nix
├── flake.lock
├── docs/
├── hosts/
│   ├── laptop/
│   ├── desktop/
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   ├── server/
│   └── vm/
├── modules/
|   └── common/
|       └── users/
|           ├── root/
|           ├── me/
|           └── guest/
├── nixos/
|   ├── core/
|   |   ├── bootloader/
|   |   |   └── default.nix
|   |   ├── shell/
|   |   |   └── fish/
|   |   |       └── default.nix
|   |   ├── nix/
|   |   |   └── options/
|   |   |       └── default.nix
|   |   └── kernel/
|   └── optional/
|       ├── drivers/
|       |   └── gpu/
|       |       ├── gpu/
|       |       └── nvidia/
|       └── wifi/
|           ├── home/
|           |   └── default.nix
|           └── work/
|               └── default.nix
├── home/
│   ├── default.nix
│   ├── core/
|   |   ├── pkgs/
│   │   └── fish/
|   ├── optional/
|   |   └── desktop/
|   |       └── hyperland/
|   └── users/
|       └── me/
|           └── pkgs/
|               └── git/
├── overlays/
|   └── ...
├── secrets/
└── wallpaper.jpg
```
+ `flake.nix`: The entry file that will be recognized and deployed when executing `sudo nixos-rebuild switch`.
+ `flake.lock`: An automatically generated version-lock file that records all input sources, hash values, and version numbers of the entire flake to ensure reproducibility.
+ `hosts/`: Contains subdirectories for each machine, with a `default.nix` for system-specific settings and a `hardware-configuration.nix` for hardware-specific configurations.
+ `modules/`: Contains reusable NixOS modules that can be shared across different hosts.
+ `nixos/`:
+ `home/`: Manages user-specific configurations using home-manager, with subdirectories for programs and services.
+ `overlays/`: Contain custom package definitions or modifications.
+ `secrets/`: