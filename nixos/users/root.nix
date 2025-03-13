{ mergedSetup, ... }:
{
  group = "root";
  isNormalUser = false;
  extraGroups = [
    "wheel"
  ];
  password = "root";
  # hashedPassword = "$6$9kBLqUdAM7HL/woP$7M.oa2WdVlOP6PyMNpKHX2Mn5fBe49Z6y/uVi2B9x/G2hjg5uYHhGb354KA97Uz/9pOVTNcrZ4tqatWITR82o1";

  # security.sudo.wheelNeedsPassword = false;

  openssh.authorizedKeys.keys = mergedSetup.networking.internet.ssh.root.authorizedKeys;
}
