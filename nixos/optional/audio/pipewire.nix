{
  lib,
  config,
  pkgs,
  isGui,
  ...
}:
{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    pipewire # Modern audio and video server for Linux
    pavucontrol # PulseAudio Volume Control GUI
  ];
}
