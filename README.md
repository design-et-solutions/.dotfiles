# README
Let's use template.\
Templates are there to help you start your Nix project.\

## Dependecy
+ Install git, if you haven't already.
+ Enable SSH.
+ Create a repository for your `config` or clone this repo.
+ Make Nix config to use the bellow options:
  ```sh
  export NIX_CONFIG="experimental-features = nix-command flakes"
  ```

## Initialization
+ Go into `config` dir, previsously added.
+ Update the lock file `flake.lock` of `flake.nix` with:
  ```sh
  nix flake update
  ```
+ Rebuild and switch the system configuration based on a specific flake configuration.
  ```sh
  nixos-rebuild switch --flake .#hostname
  ```

## Tree
```
config/
├── flake.nix
├── flake.lock
├── docs/
|   ├── hyperland/
|   |   ├── README.md
|   |   └── ...
|   └── nix/
|       ├── README.md
|       └── ...
├── home-manager/
|   └── home.nix
└── nixos/
    ├── configuration.nix
    └── hardware-configuration.nix
```

