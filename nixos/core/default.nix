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
  
  
  systemd.services = {
    gateway = {
      description = "Service gateway";
      enable = true;
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "tracker.service"];
      requires = ["tracker.service"];
      serviceConfig = {
        # ExecStart = "/home/me/Manager/core/gateway";
        ExecStart = "${pkgs.nix}/bin/nix-shell /home/me/Manager/core/gateway/nix/shell.nix --run \"/home/me/Manager/core/gateway/target/debug/gateway\"";
        Restart = "always";
        RestartSec = "30s";
        Environment = [
          "RUST_LOG='DEBUG'"
          "APP_HOST='0.0.0.0'"
          "APP_PORT=8080"
          "PRIVATE_KEY=/home/me/Manager/core/gateway/key.pem"
          "CERTIFICATE=/home/me/Manager/core/gateway/cert.pem"
          "TRACKER_HOST='0.0.0.0'"
          "TRACKER_PORT=50200"        
        ];
      };
    };

    tracker = {
      description = "Service Tracker";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "/home/me/Manager/core/tracker/target/release/registry";
        Restart = "always";
        RestartSec = "30s";
        Environment = [
          "RUST_LOG='DEBUG'"
          "APP_HOST='0.0.0.0'"
          "APP_PORT=50200"
        ];
      };
    };

  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
