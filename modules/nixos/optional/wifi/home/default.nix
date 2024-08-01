{ 
  pkgs, 
  ... 
}:
{
  networking.wireless = {
    enable = true;  # Enables wireless support via wpa_supplicant
    userControlled.enable = true;
    networks = {
      "Sweet_Home_2G" = {
        psk = "oh!sweethome";
      };
      "Sweet_Home_5G" = {
        psk = "oh!sweethome";
      };
    };
  };

  # Install useful networking tools
  environment.systemPackages = with pkgs; [
    iw
    wirelesstools
  ];
}