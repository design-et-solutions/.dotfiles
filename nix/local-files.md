# Working with local files
To build a local project in a Nix derivation, source files must be accessible to its builder executable.\
Since by default, the builder runs in an isolated environment that only allows reading from the Nix store, the Nix language has built-in features to copy local files to the store and expose the resulting store paths.

Using these features directly can be tricky however:
+ Coercion of paths to strings, such as the wide-spread pattern of `src = ./.`, makes the derivation dependent on the name of the current directory.\
  Furthermore, it always adds the entire directory to the store, including unneeded files, which causes unnecessary new builds when they change.
+ The `builtins.path` function (and equivalently `lib.sources.cleanSourceWith`) can address these problems.\
  However, it’s often hard to express the desired path selection using the `filter` function interface.
