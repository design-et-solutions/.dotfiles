{ ... }:{
  group = "bodyguard";
  isNormalUser = true;
  home = "/home/bodyguard";
  extraGroups = [ "wheel" "systemd-journal" "docker" "disk" "dialout" ];
  password = "bodyguard";
}
