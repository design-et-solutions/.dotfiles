{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./bootloader
    ./shell/fish
    ./pkgs/git
    ./pkgs/monitoring
    ./pkgs/network
    ./pkgs/rust
    ./pkgs/ssh
    ./pkgs/usb
    ./pkgs/mermaid
  ];

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = true;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  programs.nix-ld.enable = true; # run unpatched dynamic binaries on NixOS

  services.dbus.enable = true;   # inter-process communication (IPC), allows apps to comm with one another

  # tools and libs
  environment.systemPackages = with pkgs; [
    nix-prefetch-git

    libnotify   # notification manager
    gcc         # collection of compilers
    unzip
    tree
    websocat
    parted
    nodejs_22
    glib
    glib.dev
    pkg-config
    openssl
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
