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

  networking= {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 8080 ];
      allowedUDPPorts = [ 53 ];
    };
  };


  programs.nix-ld.enable = true; # run unpatched dynamic binaries on NixOS

  services.dbus.enable = true;   # inter-process communication (IPC), allows apps to comm with one another

  environment.systemPackages = with pkgs; [
    htop           # interactive process viewer
    networkmanager # network cli tools  
    git            # git
    libnotify      # notification manager
    gcc            # collection of compilers
    usbutils       # usb cli tools
    woeusb-ng      # tool to make boot key
    ntfs3g         # ntfs
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
