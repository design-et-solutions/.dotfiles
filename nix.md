# Nix
Nix is a tool for people who both need computers to do exactly as intended, repeatably, far into the future.
+ Reproducible development environments. ([see](#nix-shell-environment))
+ Easy installation of software over URLs.
+ Easy transfer of software environments between computers.
+ Declarative specification of Linux machines.
+ Reproducible integration testing using virtual machines.
+ Avoidance of version conflicts with already installed software.
+ Installing software from source code.
+ Transparent build caching using binary caches.
+ Strong support for software auditability.
+ First-class cross compilation support.
+ Remote builds.
+ Remote deployments.
+ Atomic upgrades and rollbacks.
## Nix shell environment
The command nix-shell will build the dependencies of the specified derivation, but not the derivation itself.\
Use any program packaged with Nix, without installing it permanently.\
Share the command invoking such a shell with others (work on all Linux distributions, WSL, and macOS).\
Like this:
```shell
nix-shell -p git --run "git --version" --pure -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/2a601aafdc5605a5133a2ca506a34a3a73377247.tar.gz
...
git version 2.33.1
```
There are three things going on here:
1. `--run` executes the given **Shell** command within the **Nix shell** and exits when it’s done. You can use this with nix-shell whenever you want to quickly run a program you don’t have installed on your machine.
2. `--pure` discards most environment variables set on your system when running the **Shell**. Use it only when the extra isolation is needed.
3. `-I` determines what to use as a source of package declarations. Leaving no doubt about which version of the packages in that collection will be used.
4. `-p` lists packages that should be present in the interpreter’s environment.
5. `-i` tells which program to use for interpreting the rest of the file
## Reproducible interpreted scripts
Using Nix to create and run reproducible interpreted scripts, also known as shebang scripts.\
Like this:
```shell
#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure
#! nix-shell -p bash cacert curl jq python3Packages.xmljson
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/2a601aafdc5605a5133a2ca506a34a3a73377247.tar.gz

curl https://github.com/NixOS/nixpkgs/releases.atom | xml2json | jq .
```
The additional shebang lines are a Nix-specific construct.\
Specify bash as the interpreter for the rest of the file with the `-i` option.\
Enable the `--pure` option to prevent the script from implicitly using programs that may already exist on the system that will run the script.\
With the `-p` option we specify the packages required for the script to run.\
The command `xml2json` is provided by the package `python3Packages.xmljson`, while `bash`, `jq`, and `curl` are provided by packages of the same name.\
`cacert` must be present for SSL authentication to work.
> [!TIP]
> Use [search.nixos.org](https://search.nixos.org/packages) to find packages providing the program you need.
The parameter of `-I` refers to a specific Git commit of the Nixpkgs repository.
\\
Make the script executable:
```shell
chmod +x nixpkgs-releases.sh
```
Run the script:
```shell
./nixpkgs-releases.sh
```
