# Reproducible interpreted scripts
Using Nix to create and run reproducible interpreted scripts, also known as shebang scripts.\
Like this:
```shell
#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure
#! nix-shell -p bash cacert curl jq python3Packages.xmljson
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/2a601aafdc5605a5133a2ca506a34a3a73377247.tar.gz

curl https://github.com/NixOS/nixpkgs/releases.atom | xml2json | jq .
```
+ The additional shebang lines are a Nix-specific construct.
+ Specify bash as the interpreter for the rest of the file with the `-i` option.
+ Enable the `--pure` option to prevent the script from implicitly using programs that may already exist on the system that will run the script.
+ With the `-p` option we specify the packages required for the script to run.
+ The command `xml2json` is provided by the package `python3Packages.xmljson`, while `bash`, `jq`, and `curl` are provided by packages of the same name. `cacert` must be present for SSL authentication to work.
+ The parameter of `-I` refers to a specific Git commit of the Nixpkgs repository.

> [!TIP]
> Use [search.nixos.org](https://search.nixos.org/packages) to find packages providing the program you need.

Make the script executable:
```shell
chmod +x nixpkgs-releases.sh
```
Run the script:
```shell
./nixpkgs-releases.sh
```
