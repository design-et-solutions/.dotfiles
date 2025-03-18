{ ... }:
{
  isNormalUser = true;
  home = "/home/bodyguard";
  extraGroups = [
    "wheel"
    "networkmanager"
    "systemd-journal"
    "docker"
    "disk"
    "dialout"
  ];
  # hashedPassword = "$6$cXs8pvLfAF6djbBy$TjyUmv9nr1.COXcrCiIJzNHti7VU28hGNV7OLaN.r5lnhF5Nss7/9b712janVROP86N752S7.QAGNbux5VD130";
  password = "guard";
}
