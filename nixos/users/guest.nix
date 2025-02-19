{ ... }:
{
  group = "guest";
  isNormalUser = true;
  home = "/home/guest";
  extraGroups = [
    "audio"
    "pulse"
    "video"
    "systemd-journal"
    "docker"
    "docker"
  ];
  password = "guest";
}
