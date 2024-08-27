# Cross Compilation
Nixpkgs offers powerful tools to cross-compile software for various system types.\
The nixpkgs package collection has world-class support for cross compilation, after many years of hard work by the Nix community.
+ **build platform** is where the executable is built.
+ **host platform** is where the compiled executable runs.
  
## Determining the host platform config
The build platform is determined automatically by Nix during the configure phase.\
The host platform is best determined by running this command on the host platform:
```shell
$ $(nix-build '<nixpkgs>' -I nixpkgs=channel:nixos-23.11 -A gnu-config)/config.guess
aarch64-unknown-linux-gnu
```
In case this is not possible, the platform config has to be constructed manually via the following template:
```
<cpu>-<vendor>-<os>-<abi>
```
Note that `<vendor>` is often unknown and `<abi>` is optional.

If you can’t install Nix, find a way to run `config.guess` (usually comes with the autoconf package) from the OS you’re able to run on the host platform.

## Choosing the host platform with Nix
`nixpkgs` comes with a set of predefined host platforms for cross compilation called `pkgsCross`.\
It is possible to explore them in `nix repl`:
```shell
$ nix repl '<nixpkgs>' -I nixpkgs=channel:nixos-23.11
Welcome to Nix 2.18.1. Type :? for help.

Loading '<nixpkgs>'...
Added 14200 variables.

nix-repl> pkgsCross.<TAB>
pkgsCross.aarch64-android             pkgsCross.musl-power
pkgsCross.aarch64-android-prebuilt    pkgsCross.musl32
pkgsCross.aarch64-darwin              pkgsCross.musl64
pkgsCross.aarch64-embedded            pkgsCross.muslpi
pkgsCross.aarch64-multiplatform       pkgsCross.or1k
pkgsCross.aarch64-multiplatform-musl  pkgsCross.pogoplug4
pkgsCross.aarch64be-embedded          pkgsCross.powernv
pkgsCross.amd64-netbsd                pkgsCross.ppc-embedded
pkgsCross.arm-embedded                pkgsCross.ppc64
pkgsCross.armhf-embedded              pkgsCross.ppc64-musl
pkgsCross.armv7a-android-prebuilt     pkgsCross.ppcle-embedded
pkgsCross.armv7l-hf-multiplatform     pkgsCross.raspberryPi
pkgsCross.avr                         pkgsCross.remarkable1
pkgsCross.ben-nanonote                pkgsCross.remarkable2
pkgsCross.fuloongminipc               pkgsCross.riscv32
pkgsCross.ghcjs                       pkgsCross.riscv32-embedded
pkgsCross.gnu32                       pkgsCross.riscv64
pkgsCross.gnu64                       pkgsCross.riscv64-embedded
pkgsCross.i686-embedded               pkgsCross.scaleway-c1
pkgsCross.iphone32                    pkgsCross.sheevaplug
pkgsCross.iphone32-simulator          pkgsCross.vc4
pkgsCross.iphone64                    pkgsCross.wasi32
pkgsCross.iphone64-simulator          pkgsCross.x86_64-embedded
pkgsCross.mingw32                     pkgsCross.x86_64-netbsd
pkgsCross.mingwW64                    pkgsCross.x86_64-netbsd-llvm
pkgsCross.mmix                        pkgsCross.x86_64-unknown-redox
pkgsCross.msp430
```
These attribute names for cross compilation packages have been chosen somewhat freely over the course of time.\
They usually do not match the corresponding platform config string.

You can retrieve the platform string from `pkgsCross.<platform>.stdenv.hostPlatform.config`:
```shell
nix-repl> pkgsCross.aarch64-multiplatform.stdenv.hostPlatform.config
"aarch64-unknown-linux-gnu"
```

## Specifying the host platform
The mechanism for setting up cross compilation works as follows:
+ Take the build platform configuration and apply it to the current package set, called pkgs by convention.\
  The build platform is implied in `pkgs = import <nixpkgs> {}` to be the current system.\
  This produces a build environment `pkgs.stdenv` with all the dependencies present to compile on the build platform.
+ Apply the appropriate host platform configuration to all the packages in `pkgsCross`.\
  Taking `pkgs.pkgsCross.<host>.hello` will produce the package hello compiled on the build platform to run on the `<host>` platform.

There are multiple equivalent ways to access packages targeted to the host platform.
+ Explicitly pick the host platform package from within the build platform environment:
  ```nix
  let
    nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/release-23.11";
    pkgs = import nixpkgs {};
  in
  pkgs.pkgsCross.aarch64-multiplatform.hello
  ```
+ Pass the host platform to `crossSystem` when importing `nixpkgs`.\
  This configures `nixpkgs` such that all its packages are build for the host platform:
  ```nix
  let
    nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/release-23.11";
    pkgs = import nixpkgs { crossSystem = { config = "aarch64-unknown-linux-gnu"; }; };
  in
  pkgs.hello
  ```
  Equivalently, you can pass the host platform as an argument to `nix-build`:
  ```shell
  $ nix-build '<nixpkgs>' -I nixpkgs=channel:nixos-23.11 \
    --arg crossSystem '{ config = "aarch64-unknown-linux-gnu"; }' \
    -A hello
  ```

## Cross compiling for the first time
To cross compile a package like hello, pick the platform attribute — `aarch64-multiplatform` in our case — and run:
```shell
$ nix-build '<nixpkgs>' -I nixpkgs=channel:nixos-23.11 \
  -A pkgsCross.aarch64-multiplatform.hello
...
/nix/store/1dx87l5rav8679lqigf9xxkb7wvh2m4k-hello-aarch64-unknown-linux-gnu-2.12.1
```

> [!NOTE]
> The hash of the package in the store path changes with the updates to the channel.

## Real-world cross compiling of a Hello World example
To show off the power of cross compilation in Nix, let’s build our own Hello World program by cross compiling it as static executables to `armv6l-unknown-linux-gnueabihf` and `x86_64-w64-mingw32` (Windows) platforms and run the resulting executable with an emulator.

Given we have a `cross-compile.nix`:
```nix
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/release-23.11";
  pkgs = import nixpkgs {};

  # Create a C program that prints Hello World
  helloWorld = pkgs.writeText "hello.c" ''
    #include <stdio.h>

    int main (void)
    {
      printf ("Hello, world!\n");
      return 0;
    }
  '';

  # A function that takes host platform packages
  crossCompileFor = hostPkgs:
    # Run a simple command with the compiler available
    hostPkgs.runCommandCC "hello-world-cross-test" {} ''
      # Wine requires home directory
      HOME=$PWD

      # Compile our example using the compiler specific to our host platform
      $CC ${helloWorld} -o hello

      # Run the compiled program using user mode emulation (Qemu/Wine)
      # buildPackages is passed so that emulation is built for the build platform
      ${hostPkgs.stdenv.hostPlatform.emulator hostPkgs.buildPackages} hello > $out

      # print to stdout
      cat $out
    '';
in {
  # Statically compile our example using the two platform hosts
  rpi = crossCompileFor pkgs.pkgsCross.raspberryPi;
  windows = crossCompileFor pkgs.pkgsCross.mingwW64;
}
```
If we build this example and print both resulting derivations, we should see “Hello, world!” for each:
```shell
$ cat $(nix-build cross-compile.nix)
Hello, world!
Hello, world!
```

## Developer environment with a cross compiler
Given we have a `shell.nix`:
```nix
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/release-23.11";
  pkgs = (import nixpkgs {}).pkgsCross.aarch64-multiplatform;
in

# callPackage is needed due to https://github.com/NixOS/nixpkgs/pull/126844
pkgs.pkgsStatic.callPackage ({ mkShell, zlib, pkg-config, file }: mkShell {
  # these tools run on the build platform, but are configured to target the host platform
  nativeBuildInputs = [ pkg-config file ];
  # libraries needed for the host platform
  buildInputs = [ zlib ];
}) {}
```
And `hello.c`:
```c
#include <stdio.h>

int main (void)
{
  printf ("Hello, world!\n");
  return 0;
}
```
We can cross compile it:
```shell
$ nix-shell --run '$CC hello.c -o hello' shell.nix
```
And confirm it’s aarch64:
```shell
$ nix-shell --run 'file hello' shell.nix
hello: ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), statically linked, with debug_info, not stripped
```