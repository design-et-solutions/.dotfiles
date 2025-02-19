{ ... }:
{
  group = "me";
  isNormalUser = true;
  home = "/home/me";
  extraGroups = [
    "wheel"
    "networkmanager"
    "audio"
    "guest"
    "pulse"
    "video"
    "systemd-journal"
    "docker"
    "disk"
    "dialout"
    "docker"
  ];
  password = "me";
}
