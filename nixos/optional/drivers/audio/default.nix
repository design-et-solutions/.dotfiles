{ lib, config, pkgs, isGui, ... }:
{
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };


  # environment.systemPackages = with pkgs; [
  #   lib.optionals isGui [
  #     pavucontrol
  #   ]
  # ];
}
