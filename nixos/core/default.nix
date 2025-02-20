{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./bootloader.nix
    ./shell
    ./networking.nix
    ./security
    ./system
    ./users.nix
    ./git.nix
    ./dev.nix
    ./misc.nix
    ./monitoring.nix
    ./usb.nix
  ];

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
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
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  environment.systemPackages = with pkgs; [
    gcc # GNU Compiler Collection (C and C++ compilers)
    glibc # GNU C Library, the standard C library
    nix-index # Indexes the Nix store to allow fast file lookup
    nix-ld # Run unpatched dynamic binaries on NixOS
    pkg-config # Helper tool used when compiling applications
    clang # C language family frontend for LLVM
  ];

  system.activationScripts.createMnt = ''
    mkdir -p /mnt
  '';

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
