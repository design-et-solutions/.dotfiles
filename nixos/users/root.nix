{ mergedSetup, ... }:
{
  group = "root";
  isNormalUser = false;
  extraGroups = [
    "wheel"
  ];
  # password = "root";
  hashedPassword = "$6$T73W/kgEMgyjT/iQ$NUYVlgjwZSxqrCoJ.aQt0B6Hu/e62Oi4/s2oR0ZGDUvtSBe0Isa49DexpBumM0NekLDvfF64KJDmJMnzXrVRK1";

  # security.sudo.wheelNeedsPassword = false;

  openssh.authorizedKeys.keys = mergedSetup.networking.internet.ssh.root.authorizedKeys;
}
