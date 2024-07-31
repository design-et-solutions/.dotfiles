# README
The idea is: 
+ `core` refers to `modules` that will be on all machines.
+ `optional`... you guessed it.
+ `modules/common/users` is where `optional` & `core` which refers to `pkgs`.
+ `hosts/` import the rest.


## Usage Guidelines
+ If an `option` is used once -> `hosts/` 
+ If an `option` is used twice on specific devices -> `modules/.../optional`
+ If an `option` is used systematically -> `modules/.../core`

## Secrets Management
Secrets are managed using SOPS.\
The configuration for SOPS is located in the `.sops.yml` file, and secrets are stored in the `secrets/` directory.
## Documentation
Additional documentation is available in the `docs/` directory.\
This includes specific guides for hyperland and nix.
## Testing
Tests for the configurations are located in the `tests/` directory.

## Add a user
1. create a new sub-directory in `hosts/`
2. copy and paste a template `user`.
3. add the missing drivers `modules/nixos/optional/drivers` or any other `optional` module. 

## Reload
+ Rebuild NixOS system configuration
  ```sh
  sudo nixos-rebuild switch --flake .#hostname
  ```
+ Apply home-manager configuration
  ```sh
  home-manager switch --flake .#username@hostname
  ```
## Dependecy
+ Enable Git.
+ Enable SSH.
+ Create a repository for your `config` or clone this repo.
+ Add stuff you currently have on `/etc/nixos/` to `/modules/nixos/`.
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
  > [!TIP]
  > If any error occured check it with:
  > ```sh
  > nix flake check
  > ```

## Tree
```
config/
├── flake.nix
├── flake.lock
├── .sops.yml
├── README.md
├── docs/
|   ├── hyperland/
|   |   ├── README.md
|   |   └── ...
|   └── nix/
|       ├── README.md
|       └── ...
├── hosts/
|   ├── desktop
|   |   └── home/
|   |       └── default.nix
|   ├── laptop
|   |   └── work/
|   |       └── default.nix
|   ├── server
|   |   └── rpi5
|   |       └── home/
|   |           └── default.nix
|   └── template/
|       └── default.nix
├── modules/
|   ├── common/
|   |   └── users/
│   │       ├── root/
│   │       │   ├── nixos/
│   │       │   └── home/
|   |       ├── me/
|   |       |   ├── home/
|   |       |   |   └── default.nix
|   |       |   └── nixos/
│   │       │   └── darwin/
│   │       └── guest/
│   │           ├── nixos/
│   │           ├── home/
│   │           └── darwin/
|   ├── darwin/
|   |   ├── core/
|   |   └── optional/
|   ├── home/
|   |   ├── core/
|   |   |   ├── fish/
|   |   |   └── pkgs/
|   |   ├── optional/
|   |   |   ├── desktop/
|   |   |   |   └── hyperland/
|   |   |   |       └── default.nix
|   |   |   └── pkgs/
|   |   |       └── firefox/
|   |   |           └── default.nix
|   |   └── users/
|   |       └── me/
|   |           └── pkgs/
|   |               └── git/
|   |                   └── default.nix
|   └── nixos/
|       ├── core/
│       │   ├── bootloader/
│       │   │   └── default.nix
│       │   ├── zswap/
│       │   │   └── default.nix
│       │   ├── shell/
│       │   │   └── fish/
│       │   │       └── default.nix
│       │   ├── nix/
│       │   │   └── options/
│       │   │       └── default.nix
│       │   └── ...
|       └── optional
│           ├── wifi/
│           │   ├── home/
│           │   │   └── default.nix
│           │   └── work/
│           │       └── default.nix
│           ├── drivers/
│           │   └── gpu/
│           │       ├── amd/
│           │       └── nvidia/
│           └── ...
├── tests/
└── secrets/
    ├── hosts.yml
    └── ...
```

