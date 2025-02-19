{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    noto-fonts-emoji
  ];

  fonts.fontconfig.enable = true;
}
