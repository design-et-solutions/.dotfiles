{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  fonts.fontconfig.enable = true;
}
