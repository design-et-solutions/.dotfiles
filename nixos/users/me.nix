{ ... }:
{
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
  # hashedPassword = "$6$E280K2LZktjmDkQV$5eSLAIx3fWw807sc9Du8TLS2CUjSj6HdqhPff1NobZnK8D53PoScBtu3XxQuVIJ79mHMQeHiPAtfOYhspux2J1";
  password = "me";
}
