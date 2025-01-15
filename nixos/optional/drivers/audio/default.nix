{ lib, config, pkgs, isGui, ... }:
{
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    pipewire
    pavucontrol
    pulseaudio
  ];
}
