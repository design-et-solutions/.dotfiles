# Nix Packaging
## Packaging existing software with Nix
A package is a loosely defined concept that refers to either a collection of files and other data, or a Nix expression representing such a collection before it comes into being.\
Nixpkgs have a conventional structure, allowing them to be discovered in searches and composed in environments alongside other packages.\

> [!NOTE]
> A “package” is a Nix language function that will evaluate to a derivation.\
> It will enable you or others to produce an artifact for practical use, as a consequence of having “packaged existing software with Nix”.

### A package function
Create a nix file:
```nix
# hello.nix
{
  stdenv,
  fetchzip,
}:
stdenv.mkDerivation {
  pname = "hello";
  version = "2.12.1";

  src = fetchzip {
    url = "https://ftp.gnu.org/gnu/hello/hello-2.12.1.tar.gz";
    sha256 = "";
  };
}
```
+ Add a `pname` attribute to the set passed to `mkDerivation`.

  > [!NOTE]
  > Every package needs a name and a version, and Nix will throw error: derivation name missing without.
+ Declare a dependency on the latest version of hello, and instruct Nix to use fetchzip to download the source code archive.

  > [!NOTE]
  > The hash cannot be known until after the archive has been downloaded and unpacked.\
  > Nix will complain if the hash supplied to fetchzip is incorrect.\
  > Set the hash attribute to an empty string and then use the resulting error message to determine the correct hash.

### Building with `nix-build`
`stdenv` is available from `nixpkgs`, which must be imported with another Nix expression in order to pass it as an argument to this derivation.\
The recommended way to do this is to create a `default.nix` file in the same directory as `hello.nix`, with the following contents:
```nix
# default.nix
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in
{
  hello = pkgs.callPackage ./hello.nix { };
}
```
This allows you to run `nix-build -A hello` to realize the derivation in hello.nix, similar to the current convention used in Nixpkgs.

> [!NOTE]
> `callPackage` automatically passes attributes from `pkgs` to the given function, if they match attributes required by that function’s argument attribute set.
> In this case, `callPackage` will supply `stdenv`, and `fetchzip` to the function defined in `hello.nix`.

Now run the nix-build command with the new argument:
```shell
$ nix-build -A hello
error:
...
       … while evaluating attribute 'src' of derivation 'hello'

         at /home/nix-user/hello.nix:9:3:

            8|
            9|   src = fetchzip {
             |   ^
           10|     url = "https://ftp.gnu.org/gnu/hello/hello-2.12.1.tar.gz";

       error: hash mismatch in file downloaded from 'https://ftp.gnu.org/gnu/hello/hello-2.12.1.tar.gz':
         specified: sha256:0000000000000000000000000000000000000000000000000000
         got:       sha256:0xw6cr5jgi1ir13q6apvrivwmmpr5j8vbymp0x6ll0kcv6366hnn
       error: 1 dependencies of derivation '/nix/store/8l961ay0q0ydfsgby0ngz6nmkchjqd50-hello-2.12.1.drv' failed to build
```
As expected, the incorrect file hash caused an error, and Nix helpfully provided the correct one.\
We get the right `sha256`: `sha256:0000000000000000000000000000000000000000000000000000`.\
Replace it and run the previous command again:
```shell
$ nix-build -A hello
this derivation will be built:
  /nix/store/rbq37s3r76rr77c7d8x8px7z04kw2mk7-hello.drv
building '/nix/store/rbq37s3r76rr77c7d8x8px7z04kw2mk7-hello.drv'...
...
configuring
...
configure: creating ./config.status
config.status: creating Makefile
...
building
... <many more lines omitted>
```

> [!TIP]
> It wasn’t necessary to write any build instructions in this case because the `stdenv` build system is based on GNU Autoconf, which automatically detected the structure of the project directory.

### Build result
```shell
$ ls
default.nix hello.nix  result
```
This result is a symbolic link to a Nix store location containing the built binary; you can call ./result/bin/hello to execute this program:
```shell
$ ./result/bin/hello
Hello, world!
```

### A package with dependencies
Change `default.nix` with this contents:
```nix
# default.nix
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in
{
  hello = pkgs.callPackage ./hello.nix { };
  icat = pkgs.callPackage ./icat.nix { };
}
```
A hash must also be supplied.\
This time, instead of using the empty string and letting nix-build report the correct one in an error, you can fetch the correct hash in the first place with the `nix-prefetch-url` command.\
You need the SHA256 hash of the contents of the tarball (as opposed to the hash of the tarball file itself). Therefore pass the --unpack and --type sha256 arguments:
```shell
$ nix-prefetch-url --unpack https://github.com/atextor/icat/archive/refs/tags/v0.5.tar.gz --type sha256
path is '/nix/store/p8jl1jlqxcsc7ryiazbpm7c1mqb6848b-v0.5.tar.gz'
0wyy2ksxp95vnh71ybj1bbmqd5ggp13x3mk37pzr99ljs9awy8ka
```
If you search for imlib2 on search.nixos.org, you’ll find that imlib2 is already in Nixpkgs.\
Add this package to your build environment by adding `imlib2` to the arguments of the function in `icat.nix`.\
Then add the argument’s value `imlib2` to the list of `buildInputs` in `stdenv.mkDerivation`.\
Create a file called `icat.nix`:
```nix
# icat.nix
{
  stdenv,
  fetchFromGitHub,
  imlib2,
  xorg,
}:

stdenv.mkDerivation {
  pname = "icat";
  version = "v0.5";

  src = fetchFromGitHub {
    owner = "atextor";
    repo = "icat";
    rev = "v0.5";
    sha256 = "0wyy2ksxp95vnh71ybj1bbmqd5ggp13x3mk37pzr99ljs9awy8ka";
  };

  buildInputs = [ imlib2, xorg.libX11 ];
}
```
> [!NOTE]
> Nix is lazily-evaluated, using `xorg.libX11` means that we only include the `libX11` attribute and the derivation doesn’t actually include all of `xorg` into the build context.

Run build command:
```shell
$ nix-build -A icat
this derivation will be built:
  /nix/store/x1d79ld8jxqdla5zw2b47d2sl87mf56k-icat.drv
...
error: builder for '/nix/store/x1d79ld8jxqdla5zw2b47d2sl87mf56k-icat.drv' failed with exit code 2;
       last 10 log lines:
       >   195 | # warning "_BSD_SOURCE and _SVID_SOURCE are deprecated, use _DEFAULT_SOURCE"
       >       |   ^~~~~~~
       > icat.c: In function 'main':
       > icat.c:319:33: warning: ignoring return value of 'write' declared with attribute 'warn_unused_result' [8;;https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html#index-Wunused-result-Wunused-result8;;]
       >   319 |                                 write(tempfile, &buf, 1);
       >       |                                 ^~~~~~~~~~~~~~~~~~~~~~~~
       > gcc -o icat icat.o -lImlib2
       > installing
       > install flags: SHELL=/nix/store/8fv91097mbh5049i9rglc73dx6kjg3qk-bash-5.2-p15/bin/bash install
       > make: *** No rule to make target 'install'.  Stop.
       For full logs, run 'nix log /nix/store/x1d79ld8jxqdla5zw2b47d2sl87mf56k-icat.drv'.
```
The missing dependency error is solved, but there is now another problem: `make: *** No rule to make target 'install'.  Stop`.

### `installPhase`
`stdenv` is automatically working with the `Makefile` that comes with `icat`.\
The console output shows that `configure` and `make` are executed without issue, so the `icat` binary is compiling successfully.\
The failure occurs when the `stdenv` attempts to run `make install`.\
The `Makefile` included in the project happens to lack an `install` target.\
In Nix, the output directory is stored in the `$out` variable.\
That variable is accessible in the derivation’s `builder` execution environment.\
The `README` in the `icat` repository only mentions using `make` to build the tool, leaving the installation step up to users.\
Create a `bin` directory within the `$out` directory and copy the `icat` binary there.\
So add this contents into `icat.nix`:
```nix
# icat.nix
...
  installPhase = ''
    mkdir -p $out/bin
    cp icat $out/bin
  '';
}
```

### Phases and hooks
Nixpkgs `stdenv.mkDerivation` derivations are separated into phases.\
Each is intended to control some aspect of the build process.
`stdenv.mkDerivation` automatically determined the `buildPhase` information for the `icat` package.

During derivation realisation, there are a number of shell functions (“hooks”, in Nixpkgs) which may execute in each derivation phase.\
Hooks do things like set variables, source files, create directories, and so on.

These are specific to each phase, and run both before and after that phase’s execution.\
They modify the build environment for common operations during the build.

It’s good practice when packaging software with Nix to include calls to these hooks in the derivation phases you define, even when you don’t make direct use of them.\
This facilitates easy overriding of specific parts of the derivation later.\
And it keeps the code tidy and makes it easier to read.\
Adjust your installPhase to call the appropriate hooks:
```nix
# icat.nix
...
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp icat $out/bin
    runHook postInstall
  '';
...
```

## Package parameters and overrides with callPackage
Nix ships with a special-purpose programming language for creating packages and configurations: the Nix language.\
It is used to build the Nix package collection, known as Nixpkgs.\
Nixpkgs is a sizeable software project on its own, with coding conventions and idioms that have emerged over the years.\
It has established a convention of composing parameterised packages with automatic settings through a function named `callPackage`.

### Automatic function calls
Create a new file `hello.nix`, which could be a typical package recipe as found in Nixpkgs: A function that takes an attribute set, with attributes corresponding to derivations in the top-level package set, and returns a derivation.
```nix
{ writeShellScriptBin }:
writeShellScriptBin "hello" ''
  echo "Hello, world!"
''
```
`writeShellScriptBin` is a function that happens to exist in Nixpkgs, a build helper that returns a derivation.\
The derivation output in this case contains an executable shell script in `$out/bin/hello` that prints “Hello world” when run.

Now create a file `default.nix` with the following contents:
```nix
let
  pkgs = import <nixpkgs> { };
in
pkgs.callPackage ./hello.nix { }
```
Realise the derivation in default.nix and run the executable that is produced:
```shell
$ nix-build
$ ./result/bin/hello
Hello, world!
```
The argument `writeShellScriptBin` gets filled in automatically when the function in `hello.nix` is evaluated.\
For every attribute in the function’s argument, `callPackage` passes an attribute from the `pkgs` attribute set if it exists.\
It may appear cumbersome to create the extra file `hello.nix` for the package in such a simple setup.\
We have done so because this is exactly how Nixpkgs is organised: Every package recipe is a file that declares a function.\
This function takes as arguments the package’s dependencies.

### Parameterised builds
Change the `default.nix` to produce an attribute set of derivations, with the attribute `hello` containing the original derivation and pass the parameter `audience` in the second argument to `callPackage`:
```nix
let
  pkgs = import <nixpkgs> { };
in
{
  hello = hello = pkgs.callPackage ./hello.nix { audience = "people"; };
}
```
Also change hello.nix to add an additional parameter audience with default value "world":
```nix
{
  writeShellScriptBin,
  audience ? "world",
}:
writeShellScriptBin "hello" ''
  echo "Hello, ${audience}!"
''
```
Try it out:
```shell
$ nix-build -A hello
$ ./result/bin/hello
Hello, people!
```
> [!IMPORTANT]
> This pattern is used widely in Nixpkgs.

Nixpkgs is therefore not simply a huge library of pre-configured packages, but a collection of functions – package recipes – for customising packages and even entire ecosystems on the fly without duplicating code.

### Overrides
`callPackage` adds more convenience by allowing parameters to be customised after the fact using the returned derivation’s `override` function.

Add a third attribute `hello-folks` to `default.nix` and set it to `hello.override` called with a new value for `audience`:
```nix
let
  pkgs = import <nixpkgs> { };
in
rec {
  hello = pkgs.callPackage ./hello.nix { audience = "people"; };
  hello-folks = hello.override { audience = "folks"; };
}
```
`override` passes audience to the original function in `hello.nix` - it overrides whatever arguments have been passed in the original `callPackage` that produced the derivation `hello`.\
All the other parameters will remain the same.\
This is especially useful and can be often found on packages that provide many options to customise a package.\
Try it out:
```shell
$ nix-build -A hello-folks
$ ./result/bin/hello
Hello, folks!
```
> [!TIP]
> A real-world example is the `neovim` package recipe, which has has overridable arguments such as `extraLuaPackages`, `extraPythonPackages`, or `withRuby`.

### Interdependent package sets
You can actually create your own version of `callPackage`!\
This comes in handy for package sets where the recipes depend on each other.

Consider the following recursive attribute set of derivations:
```nix
let
  pkgs = import <nixpkgs> { };
in
rec {
  a = pkgs.callPackage ./a.nix { };
  b = pkgs.callPackage ./b.nix { inherit a; };
  c = pkgs.callPackage ./c.nix { inherit b; };
  d = pkgs.callPackage ./d.nix { };
  e = pkgs.callPackage ./e.nix { inherit c d; };
}
```
> [!Note]
> Here, `inherit a;` is equivalent to `a = a;`.

Previously declared derivations are passed as arguments to other derivations through `callPackage`.

In this case you have to remember to manually specify all arguments required by each package in the respective Nix file that are not in Nixpkgs.

> [!CAUTION]
> If `./b.nix` requires an argument `a` but there is no `pkgs.a`, the function call will produce an error.

Use `lib.callPackageWith` to create your own `callPackage` based on an attribute set.
```nix
let
  pkgs = import <nixpkgs> { };
  callPackage = pkgs.lib.callPackageWith (pkgs // packages);
  packages = {
    a = callPackage ./a.nix { };
    b = callPackage ./b.nix { };
    c = callPackage ./c.nix { };
    d = callPackage ./d.nix { };
    e = callPackage ./e.nix { };
  };
in
packages
```
First of all note that instead of a recursive attribute set, the names we operate on are now assigned in a `let` binding.\
It has the same property as recursive sets.\
This is how we can refer to `packages` when we merge its contents with the pre-existing attribute set `pkgs` using the `//` operator.

Your custom `callPackages` now makes available all the attributes in `pkgs` and `packages` to the called package function (the same names from `packages` taking precedence), and `packages` is being built up recursively with each call.\

This construction is only possible because the Nix language is lazily evaluated.\
That is, values are only computed when they are actually needed.\
It allows passing packages around without having fully defined it.

Each package’s dependencies are now implicit at this level (they are still explicit in each of the package files), and `callPackage` resolves them automagically.\
This relieves you from dealing with them manually, and precludes configuration errors that may only surface late into a lengthy build process.

The implicitly recursive variant can obscure the structure for software developers not familiar with lazy evaluation, making it harder to read for them than it was before.\
But this benefit really pays off for large constructions, where it is the amount of code that would obscure the structure, and where manual modifications would become cumbersome and error-prone.
