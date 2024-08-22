{ ... }:
{
  imports = [
    ../../optional/pkgs/steam
  ];

  group = "me";
  isNormalUser = true;
  home = "/home/me";
  extraGroups = [ "audio" ];
}
