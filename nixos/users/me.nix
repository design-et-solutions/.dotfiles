{ ... }:{
  group = "me";
  isNormalUser = true;
  home = "/home/me";
  extraGroups = [ "tty" "wheel" "audio" "guest" "pulse" "video" "systemd-journal" "docker" "disk" "dialout" ];
  password = "me";
}
