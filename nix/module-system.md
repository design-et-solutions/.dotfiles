# Module system
Much of the power in Nixpkgs and NixOS comes from the module system.\
The module system is a Nix language library that enables you to:
+ Declare one attribute set using many separate Nix expressions.
+ Impose dynamic type constraints on values in that attribute set.
+ Define values for the same attribute in different Nix expressions and merge these values automatically according to their type.

These Nix expressions are called modules and must have a particular structure.

## A basic module
+ A module is a function that takes an attribute set and returns an attribute set.
+ It may declare options, telling which attributes are allowed in the final outcome.
+ It may define values, for options declared by itself or other modules.
+ When evaluated by the module system, it produces an attribute set based on the declarations and definitions.

The simplest possible module is a function that takes any attributes and returns an empty attribute set:
```nix
{ ... }:
{
}
```
To define any values, the module system first has to know which ones are allowed.\
This is done by declaring options that specify which attributes can be set and used elsewhere.

### Declaring options
Options are declared under the top-level `options` attribute with `lib.mkOption`.
```nix
{ lib, ... }:
{
  options = {
    name = lib.mkOption { type = lib.types.str; };
  };
}
```

> [!NOTE]
> The `lib` argument is passed automatically by the module system.\
> This makes Nixpkgs library functions available in each module’s function body.

The attribute `type` in the argument to `lib.mkOption` specifies which values are valid for an option.\
There are several types available under `lib.types`.\
Here we have declared an option `name` of type `str`: The module system will expect a string when a value is defined.\
Now that we have declared an option, we would naturally want to give it a value.

### Defining values
Options are set or defined under the top-level `config` attribute:
```nix
{ ... }:
{
  config = {
    name = "Boaty McBoatface";
  };
}
```
In our option declaration, we created an option `name` with a string type.\
Here, in our option definition, we have set that same option to a string.

Option declarations and option definitions don’t need to be in the same file.\
Which modules will contribute to the resulting attribute set is specified when setting up module system evaluation.

### Evaluating modules
Modules are evaluated by `lib.evalModules` from the Nixpkgs library.\
It takes an attribute set as an argument, where the `modules` attribute is a list of modules to merge and evaluate.

The output of `evalModules` contains information about all evaluated modules, and the final values appear in the attribute `config`.\
`default.nix` contents:
```nix
let
  pkgs = import <nixpkgs> {};
  result = pkgs.lib.evalModules {
    modules = [
      ./options.nix
      ./config.nix
    ];
  };
in
result.config
```
Here’s a helper script to parse and evaluate our `default.nix` file with `nix-instantiate --eval` and print the output as JSON:
```bash
nix-shell -p jq --run "nix-instantiate --eval --json --strict | jq"
```
As long as every definition has a corresponding declaration, evaluation will be successful.\
If there is an option definition that has not been declared, or the defined value has the wrong type, the module system will throw an error.

Running the script `./eval.bash` should show an output that matches what we have configured:
```shell
{
  "name": "Boaty McBoatface"
}
```

## Module system deep dive
Extensive demonstration of how to wrap an existing API with Nix modules.

> [!NOTE]
> To run this example, Google API key in `$XDG_DATA_HOME/google-api/key` is needed.

### The empty module
Write the following into a file called `default.nix`:
```nix
{ ... }:
{

}
```

### Declaring options
Some helper functions are needed, which will come from the Nixpkgs library, which is passed by the module system as `lib`.
Using `lib.mkOption`, declare the `scripts.output` option to have the type `lines`:
```nix
{ lib, ... }:
{
  options = {
    type = lib.types.lines;
  };
}
```
The `lines` type means that the only valid values are strings, and that multiple definitions should be joined with newlines.

> [!NOTE]
> The name and attribute path of the option is arbitrary.\
> Here we use `scripts`, because we will add another script later, and call this one `output`, because it will output the resulting map.

### Evaluating modules
Write a new file `eval.nix` to call `lib.evalModules` and evaluate the module in `default.nix`:
```nix
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in
pkgs.lib.evalModules {
  modules = [
    ./default.nix
  ];
}
```
Run the following command:
```shell
$ nix-instantiate --eval eval.nix -A config.scripts.output
```
The error message indicates that the `scripts.output` option is used but not defined: a value must be set for the option before accessing it.

### Type checking
Add the following lines to `default.nix`:
```nix
...
+ config = {
+   scripts.output = 42;
+ };
 }
```
Now try to execute the previous command, and witness your first module error:
```shell
$ nix-instantiate --eval eval.nix -A config.scripts.output
error:
...
       error: A definition for option `scripts.output' is not of type `strings concatenated with "\n"'. Definition values:
       - In `/home/nix-user/default.nix': 42
```
The definition `scripts.output = 42;` caused a type error: integers are not strings concatenated with the newline character.

In this case, you will assign a shell command that runs `map.sh` with contents:
```shell
#!/usr/bin/env bash
set -euo pipefail

keyFile=${XDG_DATA_HOME:-~/.local/share}/google-api/key

if [[ ! -f "$keyFile" ]]; then
    mkdir -p "$(basename "$keyFile")"
    echo "No Google API key found in $keyFile" >&2
    echo "For getting one, see https://developers.google.com/maps/documentation/maps-static/start#before-you-begin" >&2
    exit 1
fi

key=$(cat "$keyFile")
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' exit

output=$tmp/output

curlArgs=(
    https://maps.googleapis.com/maps/api/staticmap
    --silent --show-error --get --output "$output" --write-out %{http_code}
)

for arg in "$@"; do
    curlArgs+=(--data-urlencode "$arg")
done

echo curl ''${curlArgs[@]@Q} >&2

curlArgs+=(--data-urlencode key="$key")

if status=$(curl "${curlArgs[@]}"); then
    if [[ "$status" != 200 ]]; then
        echo "API returned non-200 HTTP status code $status, output is" >&2
        cat "$output" >&2
        exit 1
    fi
else
    echo "curl exited with code $?" >&2
    exit 1
fi

if [[ -t 1 ]]; then
    echo "Successful, but won't output image to tty, pipe to a file or icat instead" >&2
else
    cat "$output"
fi
```
That in turn calls the Google Maps Static API to generate a world map.\
The output is passed on to display it with `feh`, a minimalistic image viewer.

Update default.nix by changing the value of scripts.output to the following string:
```nix
   config = {
-    scripts.output = 42;
+    scripts.output = ''
+      ./map.sh size=640x640 scale=2 | feh -
+    '';
   };
```

### Interlude: reproducible scripts
That simple command will likely not work as intended on your system, as it may lack the required dependencies (`curl` and `feh`).\
We can solve this by packaging the raw map script with `pkgs.writeShellApplication`.

First, make available a `pkgs` argument in your module evaluation by adding a module that sets `config._module.args`:
```nix
 pkgs.lib.evalModules {
   modules = [
+    ({ config, ... }: { config._module.args = { inherit pkgs; }; })
     ./default.nix
   ];
 }
```

> [!NOTE]
> This mechanism is currently only [documented in the module system code](https://github.com/NixOS/nixpkgs/blob/master/lib/modules.nix#L140-L182), and that documentation is incomplete and out of date.

Then change `default.nix` to have the following contents:
```nix
{ pkgs, lib, ... }: {

  options = {
    scripts.output = lib.mkOption {
      type = lib.types.package;
    };
  };

  config = {
    scripts.output = pkgs.writeShellApplication {
      name = "map";
      runtimeInputs = with pkgs; [ curl feh ];
      text = ''
        ${./map.sh} size=640x640 scale=2 | feh -
      '';
    };
  };
}
```
This will access the previously added `pkgs` argument so we can use dependencies, and copy the `map` file in the current directory into the Nix store so it’s available to the wrapped script, which will also live in the Nix store.

Run the script with:
```shell
$ nix-build eval.nix -A config.scripts.output
./result/bin/map
```
To iterate more quickly, open a new terminal and set up `entr` to re-run the script whenever any source file in the current directory changes:
```shell
$ nix-shell -p entr findutils bash --run \
  "ls *.nix | \
   entr -rs ' \
     nix-build eval.nix -A config.scripts.output --no-out-link \
     | xargs printf -- \"%s/bin/map\" \
     | xargs bash \
   ' \
  "
```
This command does the following:
+ List all `.nix` files
+ Make `entr` watch them for changes.\
  Terminate the invoked command on each change with `-r`.
+ On each change:
  + Run the nix-build invocation as above, but without adding a ./result symlink
  + Take the resulting store path and append /bin/map to it
  + Run the executable at the path constructed this way

### Declaring more options
Rather than setting all script parameters directly, we will to do that through the module system.\
This will not just add some safety through type checking, but also allow to build abstractions to manage growing complexity and changing requirements.

Let’s begin by introducing another option, `requestParams`, which will represent the parameters of the request made to the Google Maps API.

Its type will be `listOf <elementType>`, which is a list of elements of one type.

Instead of `lines`, in this case you will want the type of the list elements to be `str`, a generic string type.

The difference between `str` and `lines` is in their merging behavior: Module option types not only check for valid values, but also specify how multiple definitions of an option are to be combined into one.
+ For `lines`, multiple definitions get merged by concatenation with newlines.
+ For `str`, multiple definitions are not allowed. This is not a problem here, since one can’t define a list element multiple times.

Make the following additions to your `default.nix` file:
```nix
     scripts.output = lib.mkOption {
       type = lib.types.package;
     };
+
+    requestParams = lib.mkOption {
+      type = lib.types.listOf lib.types.str;
+    };
   };

  config = {
    scripts.output = pkgs.writeShellApplication {
      name = "map";
      runtimeInputs = with pkgs; [ curl feh ];
      text = ''
        ${./map.sh} size=640x640 scale=2 | feh -
      '';
    };
+
+    requestParams = [
+      "size=640x640"
+      "scale=2"
+    ];
   };
 }
```

### Dependencies between options

### Conditional definitions

### Default values

### Wrapping shell commands

### Splitting modules

### The `submodule` type

### Defining options in other modules

### Nested submodules

### The `strMatching` type

### Functions as submodule arguments

### The `either` and `enum` types

### The `pathType` submodule

### The `between` constraint on integer values

### The `pathStyle` submodule

### Path styling: color

### Further styling

### Wrapping up
