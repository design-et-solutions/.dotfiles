{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gimp # GNU Image Manipulation Program, a powerful open-source image editor
  ];
}
