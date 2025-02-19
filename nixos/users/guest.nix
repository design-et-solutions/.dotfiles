{ ... }:{
  group = "guest";
  isNormalUser = true;
  home = "/home/guest";
  extraGroups = [ "audio" "video" "systemd-journal" "pulse" ];
  # password = "guest";
  hashedPassword = "$6$OKgDFi5FepLAah1f$i4KftCYXTnUx2oSQ2NCTCcfsHeyyVL8A5NU/g.UexKgHMVaWskvX6W1yckbuL9GalSUiT2Bxz66k0u4HlEbiC.";
}
