# README
## Initialization
### Prelude
+ Create a repository for your `config` or clone this repo.
+ Add `/etc/nixos/hardware-configuration.nix` to `/modules/nixos/`.

## Reload
+ Rebuild NixOS system configuration
  ```sh
  sudo nixos-rebuild switch --flake .#hostname
  ```
+ Apply home-manager configuration
  ```sh
  home-manager switch --flake .#username@hostname
  ```