{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nerd-fonts.fira-code
    noto-fonts-emoji
  ];

  fonts.fontconfig.enable = true;
}
