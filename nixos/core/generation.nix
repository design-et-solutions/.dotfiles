{ pkgs, lib, ... }:
{
  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
  };

  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delette-older-than 10d";
    };
    settings.auto-optimise-store = true;
  };
}
