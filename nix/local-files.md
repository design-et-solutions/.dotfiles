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

## Difference
To be able to copy both files `hello.txt` and `world.txt` to the output, add the whole project directory as a source again:
```nix  build.nix
...
-  sourceFiles = ./hello.txt;
+  sourceFiles = ./.;
...
-    cp -v hello.txt $out
+    cp -v {hello,world}.txt $out
...
```
This will work as expected:
```shell
$ nix-build
trace: /home/user/fileset (all files in directory)
this derivation will be built:
  /nix/store/fsihp8872vv9ngbkc7si5jcbigs81727-fileset.drv
...
'hello.txt' -> '/nix/store/wmsxfgbylagmf033nkazr3qfc96y7mwk-fileset/hello.txt'
'world.txt' -> '/nix/store/wmsxfgbylagmf033nkazr3qfc96y7mwk-fileset/world.txt'
...
/nix/store/wmsxfgbylagmf033nkazr3qfc96y7mwk-fileset
```
However, if you run `nix-build` again, the output path will be different!
The problem here is that `nix-build` by default creates a `result` symlink in the working directory, which points to the store path just produced:
```shell
$ ls -l result
result -> /nix/store/xknflcvjaa8dj6a6vkg629zmcrgz10rh-fileset
```
Since `src` refers to the whole directory, and its contents change when nix-build succeeds, Nix will have to start over every time.

The `difference` function subtracts one file set from another.\
The result is a new file set that contains all files from the first argument that aren’t in the second argument.

Use it to filter out `./result` by changing the `sourceFiles` definition:
<div class="code-title">example.py</div>
```nix
...
-  sourceFiles = ./.;
+  sourceFiles = fs.difference ./. ./result;
...
```
