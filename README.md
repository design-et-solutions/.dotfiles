# README
Inside each document you might found two indications:
+ `FIXME` (required)
+ `TODO` (usually tips or optional stuff you might want)

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

## Setup `config`
+ If it's your machine, enable SSH inside `/etc/nixos/configuration.nix` and generate a key:
      ```sh
      ssh-keygen
      ```
    + Add the `.pub` key to github and clone repo
+ If it's not ...
+ Make sure you're running Nix 2.4+, and opt into the experimental `flakes` and `nix-command` features:
  ```sh
  # Should be 2.4+
  nix --version
  export NIX_CONFIG="experimental-features = nix-command flakes"
  ```
  + If it's a lower version, so:
    ```sh
    nmcli device wifi list
    ...
    nmcli device wifi connect SSID-Name password wireless-password
    nix-channel --add https://channels.nixos.org/nixos-24.05 nixos
    nix-channel --update
    sudo nixos-rebuild switch --upgrade
    reboot
    ```
    + If no space left on boot partition: 
      ```sh
      sudo nix-collect-garbage -d
      ```
+ Take a look at `flake.nix`, making sure to fill out anything marked with `FIXME` or `TODO`.
+ Copy your `/etc/nixos/hardware-configuration.nix` to `./nixos/hardware-configuration.nix`.

---


2. If you want to use NixOS: add stuff you currently have on `/etc/nixos/` to `nixos` (usually `configuration.nix` and `hardware-configuration.nix`, when you're starting out).
3. If you want to use home-manager: add your stuff from `~/.config/nixpkgs` to `home-manager` (probably `home.nix`).
4. Take a look at `flake.nix`, making sure to fill out anything marked with `FIXME` or `TODO`.
5. Update your flake lock with `nix flake update`, so you get the latest packages and modules

## Usage
1. Run `sudo nixos-rebuild switch --flake .#hostname` to apply your system configuration.
2. Run `home-manager switch --flake .#username@hostname` to apply your home configuration.
   + If you don't have `home-manager` installed, try `nix shell nixpkgs#home-manager`.

## User password and secrets
+ By default, you'll be prompted for a root password when installing with `nixos-install`.\  
  After you reboot, be sure to add a password to your own account and lock root using `sudo passwd -l root`.
+ Alternatively, you can specify `initialPassword` for your user.\
  This will give your account a default password, be sure to change it after rebooting!\
  If you do, you should pass `--no-root-passwd` to `nixos-install`, to skip setting a password on the root account.
