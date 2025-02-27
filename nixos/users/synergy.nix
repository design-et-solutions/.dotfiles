{ ... }:
{
  group = "synergy";
  isNormalUser = true;
  home = "/home/synergy";
  extraGroups = [
    "wheel"
  ];
  password = "synergy";
}
