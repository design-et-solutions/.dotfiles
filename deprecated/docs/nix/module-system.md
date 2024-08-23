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
A given module generally declares one option that produces a result to be used elsewhere, in this case `scripts.output`.\
Options can depend on other options, making it possible to build more useful abstractions.\
Here, we want the `scripts.output` option to use the values of `requestParams` as arguments to the `./map` script.\
To make option values available to a module, the arguments of the function declaring the module must include the `config` attribute.

Update `default.nix` to add the `config` attribute:
```nix
-{ pkgs, lib, ... }: {
+{ pkgs, lib, config, ... }: {
```
When a module that sets options is evaluated, the resulting values can be accessed by their corresponding attribute names under `config`.

> [!NOTE]
> Option values can’t be accessed directly from the same module.\
> The module system evaluates all modules it receives, and any of them can define a particular option’s value.\
> What happens when an option is set by multiple modules is determined by that option’s type.

> [!WARNING]
> The config argument is not the same as the config attribute:
> + The `config` argument holds the result of the module system’s lazy evaluation, which takes into account all modules passed to `evalModules` and their imports.
> + The `config` attribute of a module exposes that particular module’s option values to the module system for evaluation.

Now make the following changes to `default.nix`:
```nix
   config = {
     scripts.output = pkgs.writeShellApplication {
       name = "map";
       runtimeInputs = with pkgs; [ curl feh ];
       text = ''
-        ${./map} size=640x640 scale=2 | feh -
+        ${./map} ${lib.concatStringsSep " "
+          config.requestParams} | feh -
       '';
```
Here, the value of the `config.requestParams` attribute is populated by the module system based on the definitions in the same file.

> [!NOTE]
> Lazy evaluation in the Nix language allows the module system to make a value available in the `config` argument passed to the module which defines that value.

`lib.concatStringsSep " "` is then used to join each list element from the value of `config.requestParams` into a single string, with the list elements of `requestParams` separated by a space character.\
The result of this represents the list of command line arguments to pass to the `./map` script

### Conditional definitions
Sometimes, you will want option values to be, well, optional.\
This can be useful when defining a value for an option is not required, as in the following case.

You will define a new option, `map.zoom`, to control the zoom level of the map.\
The Google Maps API will infer a zoom level if no corresponding argument is passed, a situation you can represent with the `nullOr <type>`, which represents values of type `<type>` or `null`.\
This does not automatically mean that when the option isn’t defined, the value of such an option is `null` – we still need to define a default value.

Add the `map` attribute set with the `zoom` option into the top-level `options` declaration, like so:
```nix
     requestParams = lib.mkOption {
       type = lib.types.listOf lib.types.str;
     };
+
+    map = {
+      zoom = lib.mkOption {
+        type = lib.types.nullOr lib.types.int;
+        default = null;
+      };
+    };
   };
```
To make use of this, use the `mkIf <condition> <definition>` function, which only adds the definition if the condition evaluates to `true`.\
Make the following additions to the `requestParams` list in the `config` block:
```nix
     requestParams = [
       "size=640x640"
       "scale=2"
+      (lib.mkIf (config.map.zoom != null)
+        "zoom=${toString config.map.zoom}")
     ];
   };
```
This will only add a `zoom` parameter to the script invocation if the value of `config.map.zoom` is not `null`.

### Default values
Let’s say that in our application we want to have a different default behavior that sets the zoom level to `10`, such that automatic zooming has to be enabled explicitly.\
This can be done with the `default` argument to `mkOption`.\
Its value will be used if the value of the option declaring it is not specified otherwise.\
Add the corresponding line:
```nix
     map = {
       zoom = lib.mkOption {
         type = lib.types.nullOr lib.types.int;
+        default = 10;
       };
     };
   };
```

### Wrapping shell commands
You have now declared options controlling the map dimensions and zoom level, but have not provided a way to specify where the map should be centered.\
Add the `center` option now, possibly with your own location as default value:
```nix
         type = lib.types.nullOr lib.types.int;
         default = 10;
       };
+
+      center = lib.mkOption {
+        type = lib.types.nullOr lib.types.str;
+        default = "switzerland";
+      };
     };
   };
```
To implement this behavior, you will use `geocode.sh` with contents:
```shell
#!/usr/bin/env bash
set -euo pipefail

rational_regex='-?[[:digit:]]+(\.[[:digit:]]+)?'
result_regex="$rational_regex,$rational_regex"

keyFile=${XDG_DATA_HOME:-~/.local/share}/google-api/key

if [[ ! -f "$keyFile" ]]; then
    mkdir -p "$(basename "$keyFile")"
    echo "No Google API key found in $keyFile" >&2
    echo "For getting one, see https://developers.google.com/maps/documentation/geocoding/overview#before-you-begin" >&2
    exit 1
fi

key=$(cat "$keyFile")

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' exit

output=$tmp/output

curlArgs=(
    https://maps.googleapis.com/maps/api/geocode/json
    --silent --show-error --get --output "$output" --write-out '%{http_code}'
    --data-urlencode address="$1"
)

#echo curl ''${curlArgs[@]@Q} >&2

curlArgs+=(--data-urlencode key="$key")

if status=$(curl "${curlArgs[@]}"); then
    if [[ "$status" == 200 ]]; then
        result=$(jq -r '.results[0].geometry.location as $loc | "\($loc | .lat),\($loc | .lng)"' "$output")
        if ! [[ $result =~ $result_regex ]]; then
            echo "Got a bad result of: '$result'" >&2
            exit 1
        else
            echo "$result"
        fi
    else
        echo "API returned non-200 HTTP status code $status, output is" >&2
        cat "$output" >&2
        exit 1
    fi
else
    echo "curl exited with code $?" >&2
    exit 1
fi
```
This script turns location names into coordinates.\
There are multiple ways of making a new package accessible, but as an exercise, you will add it as an option in the module system.\
First, add a new option to accommodate the package:
```nix
   options = {
     scripts.output = lib.mkOption {
       type = lib.types.package;
     };
+
+    scripts.geocode = lib.mkOption {
+      type = lib.types.package;
+    };
```
Then define the value for that option where you make the raw script reproducible by wrapping a call to it in `writeShellApplication`:
```nix
   config = {
+    scripts.geocode = pkgs.writeShellApplication {
+      name = "geocode";
+      runtimeInputs = with pkgs; [ curl jq ];
+      text = ''exec ${./geocode.sh} "$@"'';
+    };
+
     scripts.output = pkgs.writeShellApplication {
       name = "map";
       runtimeInputs = with pkgs; [ curl feh ];
```
Add another `mkIf` call to the list of `requestParams` now where you access the wrapped package through `config.scripts.geocode`, and run the executable /bin/geocode inside:
```nix
       "scale=2"
       (lib.mkIf (config.map.zoom != null)
         "zoom=${toString config.map.zoom}")
+      (lib.mkIf (config.map.center != null)
+        "center=\"$(${config.scripts.geocode}/bin/geocode ${
+          lib.escapeShellArg config.map.center
+        })\"")
     ];
   };
```
This time, you’ve used `escapeShellArg` to pass the `config.map.center` value as a command-line argument to `geocode`, string interpolating the result back into the `requestParams` string which sets the `center` value.\
Wrapping shell command execution in Nix modules is a helpful technique for controlling system changes, as it uses the more ergonomic attributes and values interface rather than dealing with the peculiarities of escaping manually.

### Splitting modules
The module schema includes the `imports` attribute, which allows incorporating further modules, for example to split a large configuration into multiple files.\
In particular, this allows you to separate option declarations from where they are used in your configuration.\
Create a new module, `marker.nix`, where you can declare options for defining location pins and other markers on the map:
```nix
{ lib, config, ... }: {

}
```
Reference this new file in `default.nix` using the imports attribute:
```nix
 { pkgs, lib, config, ... }: {

+  imports = [
+    ./marker.nix
+  ];
+
```

### The `submodule` type
We want to set multiple markers on the map.\
A marker is a complex type with multiple fields.\
This is where one of the most useful types included in the module system’s type system comes into play: `submodule`.\
This type allows you to define nested modules with their own options.\
Here, you will define a new `map.markers` option whose type is a list of submodules, each with a nested `location` type, allowing you to define a list of markers on the map.\
Each assignment of markers will be type-checked during evaluation of the top-level `config`.\
Make the following changes to `marker.nix`:
```nix
-{ pkgs, lib, config, ... }: {
+{ pkgs, lib, config, ... }:
+let
+  markerType = lib.types.submodule {
+    options = {
+      location = lib.mkOption {
+        type = lib.types.nullOr lib.types.str;
+        default = null;
+      };
+    };
+  };
+in {
+
+  options = {
+    map.markers = lib.mkOption {
+      type = lib.types.listOf markerType;
+    };
+  };
```

### Defining options in other modules
Because of the way the module system composes option definitions, you can freely assign values to options defined in other modules.\
In this case, you will use the `map.markers` option to produce and add new elements to the `requestParams` list, making your declared markers appear on the returned map – but from the module declared in `marker.nix`.\
To implement this behavior, add the following `config` block to `marker.nix`:
```nix
+  config = {
+
+    map.markers = [
+      { location = "new york"; }
+    ];
+
+    requestParams = let
+      paramForMarker =
+        builtins.map (marker: "$(${config.scripts.geocode}/bin/geocode ${
+          lib.escapeShellArg marker.location})") config.map.markers;
+    in [ "markers=\"${lib.concatStringsSep "|" paramForMarker}\"" ];
+  };
```

> [!WARNING]
> To avoid confusion with the `map` option setting and the final `config.map` configuration value, here we use the `map` function explicitly as `builtins.map`.

Here, you again used `escapeShellArg` and string interpolation to generate a Nix string, this time producing a pipe-separated list of geocoded location attributes.\
The `requestParams` value was also set to the resulting list of strings, which gets appended to the `requestParams` list defined in `default.nix`, thanks to the default merging behavior of the list type.\
When defining multiple markers, determining an appropriate center or zoom level for the map may be challenging; it’s easier to let the API do this for you.\
To achieve this, make the following additions to `marker.nix`, above the requestParams declaration:
```nix
+    map.center = lib.mkIf
+      (lib.length config.map.markers >= 1)
+      null;
+
+    map.zoom = lib.mkIf
+      (lib.length config.map.markers >= 2)
+      null;
+
     requestParams = let
       paramForMarker = marker:
         let
```
In this case, the default behavior of the Google Maps API when not passed a center or zoom level is to pick the geometric center of all the given markers, and to set a zoom level appropriate for viewing all markers at once.

### Nested submodules
Next, we want to allow multiple named users to define a list of markers each.\
For that you’ll add a `users` option with type `lib.types.attrsOf <subtype>`, which will allow you to define users as an attribute set, whose values have type `<subtype>`.\
Here, that subtype will be another submodule which allows declaring a departure marker, suitable for querying the API for the recommended route for a trip.\
This will again make use of the `markerType` submodule, giving a nested structure of submodules.\
To propagate marker definitions from `users` to the `map.markers` option, make the following changes in the `let` block:
```nix
+  userType = lib.types.submodule {
+    options = {
+      departure = lib.mkOption {
+        type = markerType;
+        default = {};
+      };
+    };
+  };
+
 in {
```
This defines a submodule type for a user, with a `departure` option of type `markerType`.
In the `options` block, above `map.markers`:
```nix
+    users = lib.mkOption {
+      type = lib.types.attrsOf userType;
+    };
```
That allows adding a `users` attribute set to `config` in any submodule that imports `marker.nix`, where each attribute will be of type `userType` as declared in the previous step.\
In the `config` block, above `map.center`:
```nix
   config = {

-    map.markers = [
-      { location = "new york"; }
-    ];
+    map.markers = lib.filter
+      (marker: marker.location != null)
+      (lib.concatMap (user: [
+        user.departure
+      ]) (lib.attrValues config.users));

     map.center = lib.mkIf
       (lib.length config.map.markers >= 1)
```
This takes all the `departure` markers from all users in the `config` argument, and adds them to `map.markers` if their `location` attribute is not `null`.\
The `config.users` attribute set is passed to `attrValues`, which returns a list of values of each of the attributes in the set (here, the set of `config.users` you’ve defined), sorted alphabetically (which is how attribute names are stored in the Nix language).\
Back in `default.nix`, the resulting `map.markers` option value is still accessed by `requestParams`, which in turn is used to generate arguments to the script that ultimately calls the Google Maps API.

### The `strMatching` type
Now that the map can be rendered with multiple markers, it’s time to add some style customizations.\
To tell the markers apart, add another option to the `markerType` submodule, to allow labeling each marker pin.

> [!TIP]
> The API documentation states that these labels must be either an uppercase letter or a number.

You can implement this with the `strMatching "<regex>"` type, where `<regex>` is a regular expression that will accept any matching values, in this case an uppercase letter or number.\
In the `let` block:
```nix
         type = lib.types.nullOr lib.types.str;
         default = null;
       };
+
+      style.label = lib.mkOption {
+        type = lib.types.nullOr
+          (lib.types.strMatching "[A-Z0-9]");
+        default = null;
+      };
     };
   };
```
Again, `types.nullOr` allows for `null` values, and the default has been set to `null`.\
In the `paramForMarker` function:
```nix
     requestParams = let
+      paramForMarker = marker:
+        let
+          attributes =
+            lib.optional (marker.style.label != null)
+            "label:${marker.style.label}"
+            ++ [
+              "$(${config.scripts.geocode}/bin/geocode ${
+                lib.escapeShellArg marker.location
+              })"
+            ];
+        in "markers=\"${lib.concatStringsSep "|" attributes}\"";
+      in
+        builtins.map paramForMarker config.map.markers;
```
Note how we now create a unique `marker` for each user by concatenating the `label` and `location` attributes together, and assigning them to the `requestParams`.\
The label for each marker is only propagated to the CLI parameters if `marker.style.label` is set.

### Functions as submodule arguments
Right now, if a label is not explicitly set, none will show up.\
But since every `users` attribute has a name, we could use that as an automatic value instead.\
This `firstUpperAlnum` function allows you to retrieve the first character of the username, with the correct type for passing to `departure.style.label`:
```nix
{ lib, config, ... }:
 let
+  # Returns the uppercased first letter
+  # or number of a string
+  firstUpperAlnum = str:
+    lib.mapNullable lib.head
+    (builtins.match "[^A-Z0-9]*([A-Z0-9]).*"
+    (lib.toUpper str));

   markerType = lib.types.submodule {
     options = {
```
By transforming the argument to `lib.types.submodule` into a function, you can access arguments within it.\
One special argument automatically available to submodules is `name`, which when used in `attrsOf`, gives you the name of the attribute the submodule is defined under:
```nix
-  userType = lib.types.submodule {
+  userType = lib.types.submodule ({ name, ... }: {
     options = {
       departure = lib.mkOption {
         type = markerType;
         default = {};
       };
     };
-  };
```
In this case, you don’t easily have access to the name from the marker submodules `label` option, where you otherwise could set a `default` value.\
Instead you can use the `config` section of the `user` submodule to set a default, like so:
```nix
+
+    config = {
+      departure.style.label = lib.mkDefault
+        (firstUpperAlnum name);
+    };
+  });

 in {
```

> [!NOTE]
> Module options have a priority, represented as an integer, which determines the precedence for setting the option to a particular value.\
> When merging values, the priority with lowest numeric value wins.\
> The `lib.mkDefault` modifier sets the priority of its argument value to 1000, the lowest precedence.\
> This ensures that other values set for the same option will prevail.

### The `either` and `enum` types
For better visual contrast, it would be helpful to have a way to change the color of a marker.\
Here you will use two new type-functions for this:
+ `either <this> <that>`, which takes two types as arguments, and allows either of them
+ `enum [ <allowed values> ]`, which takes a list of allowed values, and allows any of them

In the `let` block, add the following `colorType` option, which can hold strings containing either some given color names or an RGB value add the new compound type:
```nix
     ...
     (builtins.match "[^A-Z0-9]*([A-Z0-9]).*"
     (lib.toUpper str));

+  # Either a color name or `0xRRGGBB`
+  colorType = lib.types.either
+    (lib.types.strMatching "0x[0-9A-F]{6}")
+    (lib.types.enum [
+      "black" "brown" "green" "purple" "yellow"
+      "blue" "gray" "orange" "red" "white" ]);
+
   markerType = lib.types.submodule {
     options = {
       location = lib.mkOption {
```
This allows either strings that match a 24-bit hexadecimal number or are equal to one of the specified color names.\
At the bottom of the `let` block, add the `style.color` option and specify a default value:
```nix
           (lib.types.strMatching "[A-Z0-9]");
         default = null;
       };
+
+      style.color = lib.mkOption {
+        type = colorType;
+        default = "red";
+      };
     };
   };
```
Now add an entry to the `paramForMarker` list which makes use of the new option:
```nix
               (marker.style.label != null)
               "label:${marker.style.label}"
             ++ [
+              "color:${marker.style.color}"
               "$(${config.scripts.geocode}/bin/geocode ${
                 lib.escapeShellArg marker.location
               })"
```
In case you set many different markers, it would be helpful to have the ability to change their size individually.\
Add a new `style.size` option to `marker.nix`, allowing you to choose from the set of pre-defined sizes:
```nix
         type = colorType;
         default = "red";
       };
+
+      style.size = lib.mkOption {
+        type = lib.types.enum
+          [ "tiny" "small" "medium" "large" ];
+        default = "medium";
+      };
     };
   };
```
Now add a mapping for the size parameter in `paramForMarker`, which selects an appropriate string to pass to the API:
```nix
     requestParams = let
       paramForMarker = marker:
         let
+          size = {
+            tiny = "tiny";
+            small = "small";
+            medium = "mid";
+            large = null;
+          }.${marker.style.size};
+
```
Finally, add another `lib.optional` call to the `attributes` string, making use of the selected size:
```nix
           attributes =
             lib.optional
               (marker.style.label != null)
               "label:${marker.style.label}"
+            ++ lib.optional
+              (size != null)
+              "size:${size}"
             ++ [
               "color:${marker.style.color}"
               "$(${config.scripts.geocode}/bin/geocode ${
```

### The `pathType` submodule
So far, you’ve created an option for declaring a departure marker, as well as several options for configuring the marker’s visual representation.\
Now we want to compute and display a route from the user’s location to some destination.\
The new option defined in the next section will allow you to set an arrival marker, which together with a departure allows you to draw paths on the map using the new module defined below.\
To start, create a new `path.nix` file with the following contents:
```nix
{ lib, config, ... }:
let
  pathType = lib.types.submodule {
    options = {
      locations = lib.mkOption {
        type = lib.types.listOf lib.types.str;
      };
    };
  };
in
{
  options = {
    map.paths = lib.mkOption {
      type = lib.types.listOf pathType;
    };
  };
  config = {
    requestParams =
      let
        attrForLocation = loc:
          "$(${config.scripts.geocode}/bin/geocode ${lib.escapeShellArg loc})";
        paramForPath = path:
          let
            attributes =
              builtins.map attrForLocation path.locations;
          in
          ''path="${lib.concatStringsSep "|" attributes}"'';
      in
      builtins.map paramForPath config.map.paths;
  };
}
```
The `path.nix` module declares an option for defining a list of paths on our `map`, where each path is a list of strings for geographic locations.\
In the `config` attribute we augment the API call by setting the `requestParams` option value with the coordinates transformed appropriately, which will be concatenated with request parameters set elsewhere.\
Now import this new `path.nix` module from your `marker.nix` module:
```nix
 in {

+  imports = [
+    ./path.nix
+  ];
+
   options = {

     users = lib.mkOption {
```
Copy the `departure` option declaration to a new `arrival` option in `marker.nix`, to complete the initial path implementation:
```nix
         type = markerType;
         default = {};
       };
+
+      arrival = lib.mkOption {
+        type = markerType;
+        default = {};
+      };
     };
```
Next, add an `arrival.style.label` attribute to the `config` block, mirroring the `departure.style.label`:
```nix
     config = {
       departure.style.label = lib.mkDefault
         (firstUpperAlnum name);
+      arrival.style.label = lib.mkDefault
+        (firstUpperAlnum name);
     };
   });
```
Finally, update the return list in the function passed to `concatMap` in `map.markers` to also include the `arrival` marker for each user:
```nix
     map.markers = lib.filter
       (marker: marker.location != null)
       (lib.concatMap (user: [
-        user.departure
+        user.departure user.arrival
       ]) (lib.attrValues config.users));

     map.center = lib.mkIf
```
Now you have the basis to define paths on the map, connecting pairs of departure and arrival points.\
In the path module, define a path connecting every user’s departure and arrival locations:
```nix
   config = {
+
+    map.paths = builtins.map (user: {
+      locations = [
+        user.departure.location
+        user.arrival.location
+      ];
+    }) (lib.filter (user:
+      user.departure.location != null
+      && user.arrival.location != null
+    ) (lib.attrValues config.users));
+
     requestParams = let
       attrForLocation = loc:
         "$(geocode ${lib.escapeShellArg loc})";
```
The new `map.paths` attribute contains a list of all valid paths defined for all users.\
A path is valid only if the `departure` and `arrival` attributes are set for that user.

### The `between` constraint on integer values
Your users have spoken, and they demand the ability to customize the styles of their paths with a `weight` option.\
As before, you’ll now declare a new submodule for the path style.\
While you could also directly declare the `style.weight` option, in this case you should use the submodule to be able reuse the path style type later.\
Add the `pathStyleType` submodule option to the let block in `path.nix`:
```nix
 { lib, config, ... }:
 let
+
+  pathStyleType = lib.types.submodule {
+    options = {
+      weight = lib.mkOption {
+        type = lib.types.ints.between 1 20;
+        default = 5;
+      };
+    };
+  };
+
   pathType = lib.types.submodule {
```

> [!NOTE]
> The `ints.between <lower> <upper>` type allows integers in the given (inclusive) range.

The path weight will default to 5, but can be set to any integer value in the 1 to 20 range, with higher weights producing thicker paths on the map.\
Now add a `style` option to the `options` set further down the file:
```nix
     options = {
       locations = lib.mkOption {
         type = lib.types.listOf lib.types.str;
       };
+
+      style = lib.mkOption {
+        type = pathStyleType;
+        default = {};
+      };
     };

   };
```
Finally, update the `attributes` list in `paramForPath`:
```nix
       paramForPath = path:
         let
           attributes =
-            builtins.map attrForLocation path.locations;
+            [
+              "weight:${toString path.style.weight}"
+            ]
+            ++ builtins.map attrForLocation path.locations;
         in "path=\"${lib.concatStringsSep "|" attributes}\"";
```

### The `pathStyle` submodule
Users still can’t actually customize the path style yet.\
Introduce a new `pathStyle` option for each user.\
The module system allows you to declare values for an option multiple times, and if the types permit doing so, takes care of merging each declaration’s values together.\
This makes it possible to have a definition for the `users` option in the `marker.nix` module, as well as a `users` definition in `path.nix`:
```nix
 in {
   options = {
+
+    users = lib.mkOption {
+      type = lib.types.attrsOf (lib.types.submodule {
+        options.pathStyle = lib.mkOption {
+          type = pathStyleType;
+          default = {};
+        };
+      });
+    };
+
     map.paths = lib.mkOption {
       type = lib.types.listOf pathType;
     }
```
Then add a line using the `user.pathStyle` option in `map.paths` where each user’s paths are processed:
```nix
         user.departure.location
         user.arrival.location
       ];
+      style = user.pathStyle;
     }) (lib.filter (user:
       user.departure.location != null
       && user.arrival.location != null
```

### Path styling: color
As with markers, paths should have customizable colors.\
You can accomplish this using types you’ve already encountered by now.\
Add a new `colorType` block to `path.nix`, specifying the allowed color names and RGB/RGBA hexadecimal values:
```nix
 { lib, config, ... }:
 let

+  # Either a color name, `0xRRGGBB` or `0xRRGGBBAA`
+  colorType = lib.types.either
+    (lib.types.strMatching "0x[0-9A-F]{6}[0-9A-F]{2}?")
+    (lib.types.enum [
+      "black" "brown" "green" "purple" "yellow"
+      "blue" "gray" "orange" "red" "white"
+    ]);
+
   pathStyleType = lib.types.submodule {
```
Under the `weight` option, add a new `color` option to use the new `colorType` value:
```nix
         type = lib.types.ints.between 1 20;
         default = 5;
       };
+
+      color = lib.mkOption {
+        type = colorType;
+        default = "blue";
+      };
     };
   }
```
Finally, add a line using the `color` option to the `attributes` list:
```nix
           attributes =
             [
               "weight:${toString path.style.weight}"
+              "color:${path.style.color}"
             ]
             ++ map attrForLocation path.locations;
         in "path=${
```

### Further styling
Now that you’ve got this far, to further improve the aesthetics of the rendered map, add another style option allowing paths to be drawn as geodesics, the shortest “as the crow flies” distance between two points on Earth.\
Since this feature can be turned on or off, you can do this using the `bool` type, which can be `true` or `false`.\
Make the following changes to `path.nix` now:
```nix
         type = colorType;
         default = "blue";
       };
+
+      geodesic = lib.mkOption {
+        type = lib.types.bool;
+        default = false;
+      };
     };
   };
```
Make sure to also add a line to use that value in `attributes` list, so the option value is included in the API call:
```nix
             [
               "weight:${toString path.style.weight}"
               "color:${path.style.color}"
+              "geodesic:${lib.boolToString path.style.geodesic}"
             ]
             ++ map attrForLocation path.locations;
         in "path=${
```

### Wrapping up
In this tutorial, you’ve learned how to write custom Nix modules to bring external services under declarative control, with the help of several new utility functions from the Nixpkgs `lib`.\
You defined several modules in multiple files, each with separate submodules making use of the module system’s type checking.\
These modules exposed features of the external API in a declarative way.\
You can now conquer the world with Nix.
