{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nerd-fonts.fira-code
    # (nerdfonts.override { fonts = [ "FiraCode" ]; })
    noto-fonts-emoji
  ];

  fonts.fontconfig.enable = true;
}
