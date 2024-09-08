{ lib, config, pkgs, isGui, ... }:
{
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
    pulseaudio
  ];
}
# { lib, config, pkgs, ... }:
# {
#   hardware.pulseaudio = {
#     enable = true;
#     support32Bit = true;
#     package = pkgs.pulseaudioFull;
#     # extraModules = [ pkgs.pulseaudio-modules-bt ];
#     extraConfig = ''
#       load-module module-switch-on-connect
#     '';
#   };
#
#   nixpkgs.config.pulseaudio = true;
#
#   environment.systemPackages = with pkgs; [
#     pavucontrol
#     pulseaudio
#   ];
# }
