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
