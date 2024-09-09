{ lib, config, pkgs, isGui, ... }:
{
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };

  services.pipewire.enable = false;

  environment.systemPackages = with pkgs; [
    pavucontrol
    pulseaudio
  ];
}
