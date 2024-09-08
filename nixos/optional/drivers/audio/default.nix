{ lib, config, pkgs, isGui, ... }:
{
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };
}
