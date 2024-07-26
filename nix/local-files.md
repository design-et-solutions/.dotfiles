# Working with local files
To build a local project in a Nix derivation, source files must be accessible to its builder executable.\
Since by default, the builder runs in an isolated environment that only allows reading from the Nix store, the Nix language has built-in features to copy local files to the store and expose the resulting store paths.

Using these features directly can be tricky however:
+ Coercion of paths to strings, such as the wide-spread pattern of `src = ./.`, makes the derivation dependent on the name of the current directory.\
  Furthermore, it always adds the entire directory to the store, including unneeded files, which causes unnecessary new builds when they change.
+ The `builtins.path` function (and equivalently `lib.sources.cleanSourceWith`) can address these problems.\
  However, it’s often hard to express the desired path selection using the `filter` function interface.

## File sets
A file set is a data type representing a collection of local files.\
File sets can be created, composed, and manipulated with the various functions of the library.

You can explore and learn about the library with `nix repl`:
```shell
$ nix repl -f channel:nixos-23.11
...
nix-repl> fs = lib.fileset
```
The `trace` function pretty-prints the files included in a given file set:
```shell
nix-repl> fs.trace ./. null
trace: /home/user (all files in directory)
null
```
All functions that expect a file set for an argument can also accept a path.\
Such path arguments are then implicitly turned into sets that contain all files under the given path.\
In the previous trace this is indicated by `(all files in directory)`.

Even though file sets conceptually contain local files, these files are never added to the Nix store unless explicitly requested.\
Therefore you don’t have to worry as much about accidentally copying secrets into the world-readable store.

In this example, although we pretty-printed the home directory, no files were copied.\
This is in contrast to coercion of paths to strings such as in `"${./.}"`, which copies the whole directory to the Nix store on evaluation!

## Example project
To further experiment with the library, make a sample project.\
Create a new directory, enter it, and set up `npins` to pin the Nixpkgs dependency:
```shell
$ mkdir fileset
$ cd fileset
$ nix-shell -p npins --run "npins init --bare; npins add github nixos nixpkgs --branch nixos-23.11"
```
Then create a `default.nix` file with the following contents:
```nix
{
  system ? builtins.currentSystem,
  sources ? import ./npins,
}:
let
  pkgs = import sources.nixpkgs {
    config = { };
    overlays = [ ];
    inherit system;
  };
in
pkgs.callPackage ./build.nix { }
```
Add two source files to work with:
```shell
$ echo hello > hello.txt
$ echo world > world.txt
```
## Adding files to the Nix store
Files in a given file set can be added to the Nix store with `toSource`.\
The argument to this function requires a `root` attribute to determine which source directory to copy to the store.\
Only the files in the `fileset` attribute are included in the result.

Define `build.nix` as follows:
```nix
{ stdenv, lib }:
let
  fs = lib.fileset;
  sourceFiles = ./hello.txt;
in

fs.trace sourceFiles

stdenv.mkDerivation {
  name = "fileset";
  src = fs.toSource {
    root = ./.;
    fileset = sourceFiles;
  };
  postInstall = ''
    mkdir $out
    cp -v hello.txt $out
  '';
}
```
The call to `fs.trace` prints the file set that will be used as a derivation input.

Try building it:
```shell
nix-build
trace: /home/user/fileset
trace: - hello.txt (regular)
this derivation will be built:
  /nix/store/3ci6avmjaijx5g8jhb218i183xi7bi2n-fileset.drv
...
'hello.txt' -> '/nix/store/sa4g6h13v0zbpfw6pzva860kp5aks44n-fileset/hello.txt'
...
/nix/store/sa4g6h13v0zbpfw6pzva860kp5aks44n-fileset
```
But the real benefit of the file set library comes from its facilities for composing file sets in different ways.
