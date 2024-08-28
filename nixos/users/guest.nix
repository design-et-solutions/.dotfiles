{ ... }:
{
  group = "guest";
  isNormalUser = true;
  home = "/home/guest";
  extraGroups = [ "wheel" "audio" ];
}
