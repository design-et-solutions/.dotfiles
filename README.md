# README
## Tree
```
config/
├── flake.nix
├── flake.lock
├── .sops.yml
├── README.md
├── docs/
│   ├── hyperland/
│   │   ├── README.md
│   │   └── ...
│   ├── neovim/
│   │   ├── README.md
│   │   └── ...
│   ├── fish/
│   │   ├── README.md
│   │   └── ...
│   ├── tmux/
│   │   ├── README.md
│   │   └── ...
│   └── nix/
│       ├── README.md
│       └── ...
├── hosts/
│   ├── laptop
│   │   └── work/
│   │       ├── default.nix 
│   │       └── hardware-configuration.nix 
│   └── template/
│       ├── default.nix
│       └── hardware-configuration.nix
├── home/
│   ├── users/
│   │   └── users/
│   │       ├── default.nix
│   │       └── pkgs/
│   │           └── git/
│   │               └── default.nix
│   ├── core/
│   └── optional/
│       └── pkgs/
│           └── firefox/ 
│               └── default.nix 
├── nixos/
│   ├── core/
│   │   ├── shell/
│   │   │   └── fish/ 
│   │   │       └── default.nix 
│   │   ├── terminal-multiplexer/
│   │   │   └── tmux/ 
│   │   │       └── default.nix 
│   │   └── bootloader/
│   │       └── default.nix 
│   └── optional/
│       ├── wifi/
│       │   ├── home/
│       │   │   └── default.nix
│       │   └── work/
│       │       └── default.nix
│       ├── drivers/
│       │   ├── gpu/
│       │   │   ├── amd/
│       │   │   └── nvidia/
│       │   └── cpu/
│       │       ├── arm/
│       │       └── intel/
│       ├── display-server/
│       │   ├── wayland/ 
│       │   │   └── default.nix 
│       │   └── x11/ 
│       │       └── default.nix 
│       └── window-manager/
│           └── hyprland/ 
│               └── default.nix 
├── tests/
│   └── ...
└── secrets/
    └── ...
```
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
