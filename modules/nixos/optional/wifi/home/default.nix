{ config, lib, pkgs, ... }:
{
  networking.wireless = {
    enable = true;  # Enables wireless support via wpa_supplicant
    userControlled.enable = true;
    networks = {
      "Sweet_Home_2G" = {
        psk = "89143132fd5b6c1f3cba26e9583bb4c271a52b1ae3d88c244287ff7ee0fd1990";
      };
      "Sweet_Home_5G" = {
        psk = "6424fc5adc5fdf73903e5fbb4b70f6876e573bd48b3ce93fc25232aa6c4cadd2";
      };
      "Bbox-192379F6" = {
        psk = "8ee55c8383f81b63bf11c6bcef46cf9e19363714bf7f03ea5ac205fd0b46c26f";
      };
    };
  };

  # Enable NetworkManager for easier WiFi management
  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
  };

  # Install useful networking tools
  environment.systemPackages = with pkgs; [
    iw
    wirelesstools
    networkmanagerapplet
  ];
}