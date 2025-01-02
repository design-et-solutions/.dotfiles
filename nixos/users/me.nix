{ ... }:{
  group = "me";
  isNormalUser = true;
  home = "/home/me";
  extraGroups = [ "wheel" "networkmanager" "audio" "guest" "pulse" "video" "systemd-journal" "docker" "disk" "dialout" ];
  # password = "me";
  hashedPassword = "$6$9kBLqUdAM7HL/woP$7M.oa2WdVlOP6PyMNpKHX2Mn5fBe49Z6y/uVi2B9x/G2hjg5uYHhGb354KA97Uz/9pOVTNcrZ4tqatWITR82o1";
}
