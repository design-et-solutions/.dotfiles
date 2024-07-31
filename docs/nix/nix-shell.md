# Nix shell environment
The command nix-shell will build the dependencies of the specified derivation, but not the derivation itself.\
Use any program packaged with Nix, without installing it permanently.

> [!TIP]
> See [nix-shell]([https://search.nixos.org/packages](https://nix.dev/manual/nix/2.18/command-ref/nix-shell)) to manual.

Share the command invoking such a shell with others (work on all Linux distributions, WSL, and macOS).\
Like this:
```shell
nix-shell -p git --run "git --version" --pure -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/2a601aafdc5605a5133a2ca506a34a3a73377247.tar.gz
...
git version 2.33.1
```
+ `--run` executes the given **Shell** command within the **Nix shell** and exits when it’s done. You can use this with nix-shell whenever you want to quickly run a program you don’t have installed on your machine.
+ `--pure` discards most environment variables set on your system when running the **Shell**. Use it only when the extra isolation is needed.
+ `-I` determines what to use as a source of package declarations. Leaving no doubt about which version of the packages in that collection will be used.
