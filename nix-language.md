# Nix language basics
The Nix language is designed for conveniently creating and composing derivations – precise descriptions of how contents of existing files are used to derive new files.\
It is a domain-specific, purely functional, lazily evaluated, dynamically typed programming language.\
Using the Nix language in practice entails multiple things:
+ Language: syntax and semantics
+ Libraries: `builtins` and `pkgs.lib`
+ Developer tools: testing, debugging, linting, formatting, …
+ Generic build mechanisms: `stdenv.mkDerivation`, trivial builders, …
+ Composition and configuration mechanisms: `override`, `overrideAttrs`, `overlays`, `callPackage`, …
+ Ecosystem-specific packaging mechanisms: `buildGoModule`, `buildPythonApplication`, …
+ NixOS module system: `config`, `option`, …

> [!TIP]
> See the [Nix manual](https://nix.dev/manual/nix/2.18/language/index.html) for a full language reference.

## Nix expression
Expression:
```nix
1 + 2
```
Value:
```nix
3
```

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

## Notes on whitespace
White space is used to delimit lexical tokens, where required.\
It is otherwise insignificant.\
Line breaks, indentation, and additional spaces are for readers’ convenience.\
The following are equivalent:
```nix
let
 x = 1;
 y = 2;
in x + y
```
```nix
let x=1;y=2;in x+y
```
## Names and values
Values in the Nix language can be primitive data types, lists, attribute sets, and functions.\
Attribute sets and `let` expressions are used to assign names to values.\
Assignments are denoted by a single equal sign `=`.\
Whenever you encounter an equal sign `=` in Nix language code:
+ On its left is the assigned name.
+ On its right is the value, delimited by a semicolon `;`.

## Attribute set `{ ... }`
An attribute set is a collection of name-value-pairs, where names must be unique.

> [!NOTE]
> Nix language data types without functions work just like their counterparts in `JSON` and look very similar.

```nix
{
  string = "hello";
  integer = 1;
  float = 3.141;
  bool = true;
  null = null;
  list = [ 1 "two" false ];
  attribute-set = {
    a = "hello";
    b = 2;
    c = 2.718;
    d = false;
  }; # comments are supported
}
```

> [!NOTE]
> Attribute names usually do not need quotes.\
> List elements are separated by white space.

## Recursive attribute set rec `{ ... }`
Attribute sets declared with `rec`  allows access to attributes from within the set.\
Expression:
```nix
rec {
  one = 1;
  two = one + 1;
  three = two + 1;
}
```
Value:
```nix
{ one = 1; three = 3; two = 2; }
```

> [!NOTE]
> Elements in an attribute set can be declared in any order, and are ordered on evaluation.

## `let ... in ...`
`let` expressions allow assigning names to values for repeated use.
Expression:
```nix
let
  a = 1;
in
a + a
```
Value:
```nix
2
```
+ Assignments are placed between the keywords `let` and in.
+ After in comes the expression in which the assignments are valid, i.e., where assigned names can be used.

In the following example we use the let expression to form a list:
Expression:
```nix
let
  b = a + 1;
  c = a + b;
  a = 1;
in [ a b c ]
```
Value:
```nix
[ 1 2 3 ]
```

Only expressions within the let expression itself can access the newly declared names. We say: the bindings have local scope.

## Attribute access
Attributes in a set are accessed with a dot `.` and the attribute name.\
Expression:
```nix
let
  attrset = { a = { b = { c = 1; }; }; };
in
attrset.a.b.c
```
Value:
```shell
1
```

The dot (.) notation can also be used for assigning attributes.
Expression:
```nix
{ a.b.c = 1; }
```
Value:
```nix
{ a = { b = { c = 1; }; }; }
```

## `with ...; ...`
The `with` expression allows access to attributes without repeatedly referencing their attribute set.
Expression:
```nix
let
  a = {
    x = 1;
    y = 2;
    z = 3;
  };
in
with a; [ x y z ]
```
Value:
```nix
[ 1 2 3 ]
```
The expression:
```nix
with a; [ x y z ]
```
is equivalent to
```nix
[ a.x a.y a.z ]
```

> [!WARNING]
> Attributes made available through `with` are only in scope of the expression following the semicolon `;`.

## `inherit ...`
`inherit` is shorthand for assigning the value of a name from an existing scope to the same name in a nested scope.\
It is for convenience to avoid repeating the same name multiple times.
Expression:
```nix
let
  x = 1;
  y = 2;
in
{
  inherit x y;
}
```
Value:
```nix
[ 1 2 3 ]
```
The expression:
```nix
inherit x y;
```
is equivalent to
```nix
x = x; y = y;
```
It is also possible to `inherit` names from a specific attribute set with parentheses `inherit (...) ...`.
Expression:
```nix
let
  a = { x = 1; y = 2; };
in
{
  inherit (a) x y;
}
```
Value:
```nix
{ x = 1; y = 2; }
```
The expression:
```nix
inherit (a) x y;
```
is equivalent to
```nix
x = a.x; y = a.y;
```
`inherit` also works inside `let` expressions.
Expression:
```nix
let
  inherit ({ x = 1; y = 2; }) x y;
in [ x y ]
```
Value:
```nix
[ 1 2 ]
```

## String interpolation `${ ... }`
The value of a Nix expression can be inserted into a character string with the dollar-sign and braces `${ }`.
Expression:
```nix
let
  name = "Nix";
in
"hello ${name}"
```
Value:
```nix
"hello Nix"
```
Only character strings or values that can be represented as a character string are allowed.

Interpolated expressions can be arbitrarily nested.
Expression:
```nix
let
  a = "no";
in
"${a + " ${a + " ${a}"}"}"
```
Value:
```nix
"no no no"
```
## File system paths
Absolute paths always start with a slash `/`.\
Paths are relative when they contain at least one slash `/` but do not start with one.\
One dot `.` denotes the current directory within the given path.\
Expression:
```nix
/absolute/path
./relative
relative/path
./.
../.
```
Value:
```nix
/absolute/path
/current/directory/relative
/current/directory/relative/path
/current/directory
/current
```

## Lookup paths
Also known as “angle bracket syntax”.
Expression:
```nix
<nixpkgs>
```
Value:
```nix
/nix/var/nix/profiles/per-user/root/channels/nixpkgs
```
The value of a lookup path is a file system path that depends on the value of `builtins.nixPath`.\
In practice, `<nixpkgs>` points to the file system path of some revision of Nixpkgs.

> [!WARNING]
> While you will encounter many such examples, we recommend to avoid lookup paths in production code, as they are impurities which are not reproducible.

## Indented strings
Also known as “multi-line strings”.\
The Nix language offers convenience syntax for character strings which span multiple lines that have common indentation.\
Indented strings are denoted by double single quotes `'' ''`.\
Expression:
```nix
''
multi
line
 string
''
```
Value:
```nix
"multi\nline\n string\n"
```

## Functions
A function always takes exactly one argument.\
Argument and function body are separated by a colon `:`.\
Wherever you find a colon `:` in Nix language code:
+ On its left is the function argument
+ On its right is the function body.

Function arguments are the third way, apart from attribute sets and `let` expressions, to assign names to values.\
Notably, values are not known in advance: the names are placeholders that are filled when calling a function.\
Function declarations in the Nix language can appear in different forms:
+ Single argument
  ```nix
  x: x + 1
  ```
  + Multiple arguments via nesting
    
    ```nix
    x: y: x + y
    ```
+ Attribute set argument
  ```nix
  { a, b }: a + b
  ```
  + With default attributes
    
    ```nix
    { a, b ? 0 }: a + b
    ```
  + With additional attributes allowed
    
    ```nix
    { a, b, ...}: a + b
    ```
+ Named attribute set argument 
  ```nix
  args@{ a, b, ... }: a + b + args.c
  ```
  or
  
  ```nix
  { a, b, ... }@args: a + b + args.c
  ```

> [!NOTE]
> Functions have no names. We say they are anonymous, and call such a function a lambda.

Expression:
```nix
x: x + 1
```
Value:
```nix
<LAMBDA>
```
As with any other value, functions can be assigned to a name.\
Expression:
```nix
let
  f = x: x + 1;
in f
```
Value:
```nix
<LAMBDA>
```

## Calling functions
Also known as “function application”.\
Calling a function with an argument means writing the argument after the function.
Expression:
```nix
let
  f = x: x + 1;
in f 1
```
Value:
```nix
2
```
One can also pass arguments by name.\
Expression:
```nix
let
  f = x: x.a;
  v = { a = 1; };
in
f v
```
Value:
```nix
1
```
Since function and argument are separated by white space, sometimes parentheses `( )` are required to achieve the desired result.\
List elements are also separated by white space, therefore the following are different:
Expression:
```nix
let
 f = x: x + 1;
 a = 1;
in [ (f a) ]
```
Value:
```nix
[ 2 ]
```

## Multiple arguments
Also known as “curried functions”.\
Multiple arguments can be handled by nesting functions.\
Such a nested function can be used like a function that takes multiple arguments, but offers additional flexibility.\
Expression:
```nix
let
  f = x: y: x + y;
in
f 1
```
Value:
```nix
<LAMBDA>
```
Applying the function which results from `f 1` to another argument yields the inner body `x + y` (with `x` set to `1` and `y` set to the other argument), which can now be fully evaluated.
Expression:
```nix
let
  f = x: y: x + y;
in
f 1 2
```
Value:
```nix
3
```

## Attribute set argument
Also known as “keyword arguments” or “destructuring” .\
Nix functions can be declared to require an attribute set with specific structure as argument.\
This is denoted by listing the expected attribute names separated by commas `,` and enclosed in braces `{ }`.\
Expression:
```nix
let
  f = {a, b}: a + b;
in
f { a = 1; b = 2; }
```
Value:
```nix
3
```

## Default values
Also known as “default arguments”.\
Destructured arguments can have default values for attributes.\
This is denoted by separating the attribute name and its default value with a question mark `?`.\
Attributes in the argument are not required if they have a default value.\
Expression:
```nix
let
  f = {a ? 0, b ? 0}: a + b;
in
f { } # empty attribute set
```
Value:
```nix
0
```

## Additional attributes
Additional attributes are allowed with an ellipsis `...`:
Expression:
```nix
let
  f = {a, b, ...}: a + b;
in
f { a = 1; b = 2; c = 3; }
```
Value:
```nix
3
```

## Named attribute set argument
Also known as “@ pattern”, “@ syntax”, or “‘at’ syntax”.\
An attribute set argument can be given a name to be accessible as a whole.\
This is denoted by prepending or appending the name to the attribute set argument, separated by the at sign `@`.\
Expression:
```nix
let
  f = {a, b, ...}@args: a + b + args.c;
in
f { a = 1; b = 2; c = 3; }
```
Value:
```nix
6
```

## Function libraries
In addition to the built-in operators (`+`, `==`, `&&`, etc.), there are two widely used libraries that together can be considered standard for the Nix language.

### `builtins`
Also known as “primitive operations” or “primops”.\
These functions are available under the builtins constant.

> [!NOTE]
> The Nix manual lists all [Built-in Functions](https://nix.dev/manual/nix/2.18/language/builtins.html), and shows how to use them.

Expression:
```nix
builtins.toString
```
Value:
```nix
<PRIMOP>
```

## import
Most built-in functions are only accessible through `builtins`.\
A notable exception is `import`, which is also available at the top level.\
`import` takes a path to a Nix file, reads it to evaluate the contained Nix expression, and returns the resulting value.\
If the path points to a directory, the file `default.nix` in that directory is used instead.\
Terminal:
```shell
$ echo "x: x + 1" > file.nix
```
Expression:
```nix
import ./file.nix 1
```
Value:
```nix
2
```

### `pkgs.lib`
The `nixpkgs` repository contains an attribute set called `lib`, which provides a large number of useful functions.\
They are implemented in the Nix language, as opposed to builtins, which are part of the language itself.\
These functions are usually accessed through `pkgs.lib`, as the Nixpkgs attribute set is given the name `pkgs` by convention.

> [!NOTE]
> The Nixpkgs manual lists all [Nixpkgs library functions](https://nixos.org/manual/nixpkgs/stable/#sec-functions-library).

Expression:
```nix
let
  pkgs = import <nixpkgs> {};
in
pkgs.lib.strings.toUpper "lookup paths considered harmful"
```
Value:
```nix
LOOKUP PATHS CONSIDERED HARMFUL
```
In reproductable exemple:
```nix
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/06278c77b5d162e62df170fec307e83f1812d94b.tar.gz";
  pkgs = import nixpkgs {};
in
pkgs.lib.strings.toUpper "always pin your sources"
```
Value:
```nix
ALWAYS PIN YOUR SOURCES
```

## Impurities
In practice, describing derivations requires observing the outside world.\
There is only one impurity in the Nix language that is relevant here: reading files from the file system as build inputs.\
Build inputs are files that derivations refer to in order to describe how to derive new files.\
When run, a derivation will only have access to explicitly declared build inputs.\
The only way to specify build inputs in the Nix language is explicitly with:
+ File system paths
+ Dedicated functions

> [!IMPORTANT]
> Nix and the Nix language refer to files by their content hash.\
> If file contents are not known in advance, it’s unavoidable to read files during expression evaluation.

> [!NOTE]
> Nix supports other types of impure expressions, such as lookup paths or the constant `builtins.currentSystem`.

## Paths
Whenever a file system path is used in string interpolation, the contents of that file are copied to a special location in the file system, the Nix store, as a side effect.\
The evaluated string then contains the Nix store path assigned to that file.\
For directories the same thing happens: The entire directory (including nested files and directories) is copied to the Nix store, and the evaluated string becomes the Nix store path of the directory.

## Fetchers
Files to be used as build inputs do not have to come from the file system.\
The Nix language provides built-in impure functions to fetch files over the network during evaluation:
+ `builtins.fetchurl`
+ `builtins.fetchTarball`
+ `builtins.fetchGit`
+ `builtins.fetchClosure`

These functions evaluate to a file system path in the Nix store.\
Expression:
```nix
builtins.fetchurl "https://github.com/NixOS/nix/archive/7c3ab5751568a0bc63430b33a5169c5e4784a0ff.tar.gz"
```
Value:
```nix
"/nix/store/7dhgs330clj36384akg86140fqkgh8zf-7c3ab5751568a0bc63430b33a5169c5e4784a0ff.tar.gz"
```
Some of them add extra convenience, such as automatically unpacking archives.\
Expression:
```nix
builtins.fetchTarball "https://github.com/NixOS/nix/archive/7c3ab5751568a0bc63430b33a5169c5e4784a0ff.tar.gz"
```
Value:
```nix
"/nix/store/d59llm96vgis5fy231x6m7nrijs0ww36-source"
```

> [!NOTE]
> The Nixpkgs manual on [Fetchers](https://nixos.org/manual/nixpkgs/stable/#chap-pkgs-fetchers) lists numerous additional library functions to fetch files over the network.

> [!CAUTION]
> It is an error if the network request fails.

## Derivations
Derivations are at the core of both Nix and the Nix language:
+ The Nix language is used to describe derivations.
+ Nix runs derivations to produce build results.
+ Build results can in turn be used as inputs for other derivations.

The Nix language primitive to declare a derivation is the built-in impure function `derivation`.\
It is usually wrapped by the Nixpkgs build mechanism `stdenv.mkDerivation`, which hides much of the complexity involved in non-trivial build procedures.

> [!IMPORTANT]
> You will probably never encounter `derivation` in practice.\
> Whenever you encounter `mkDerivation`, it denotes something that Nix will eventually build.

The evaluation result of `derivation` (and `mkDerivation`) is an attribute set with a certain structure and a special property: It can be used in string interpolation, and in that case evaluates to the Nix store path of its build result.
Expression:
```nix
let
  pkgs = import <nixpkgs> {};
in "${pkgs.nix}"
```
Value:
```nix
"/nix/store/sv2srrjddrp2isghmrla8s6lazbzmikd-nix-2.11.0"
```
String interpolation on derivations is used to refer to their build results as file system paths when declaring new derivations.\
This allows constructing arbitrarily complex compositions of derivations with the Nix language.

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
