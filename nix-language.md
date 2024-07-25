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
```nix
{ a, b, ... }@args: a + b + args.c
```

> [!NOTE]
> Functions have no names. We say they are anonymous, and call such a function a lambda.
