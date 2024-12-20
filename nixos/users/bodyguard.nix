{ ... }:{
  group = "bodyguard";
  isNormalUser = true;
  home = "/home/bodyguard";
  extraGroups = [ "wheel" "systemd-journal" "docker" "disk" "dialout" ];
  # password = "bodyguard";
  hashedPassword = "$6$EOK/nvVNmIlXEfNN$Or5SVzeVfX0mh6Rrie8q0njfzucbaiwZkbTSUesGTQvoWNgbMTev8QZLs1xA/MXaejQx20lLkzAH75VPv2eAg1";
}
