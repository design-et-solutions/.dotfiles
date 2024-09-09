{ config, pkgs, ... }:
{
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;  # This allows Podman to act as a drop-in replacement for Docker
    };
  };

  environment.systemPackages = with pkgs; [
    podman
  ];
}
