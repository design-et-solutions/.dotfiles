{ ... }:{
  group = "guest";
  isNormalUser = true;
  home = "/home/guest";
  extraGroups = [ "audio" "video" "systemd-journal" "pulse" ];
}
