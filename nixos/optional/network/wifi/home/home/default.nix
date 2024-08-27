{ ... }:
{
  networking.wireless = {
    enable = true;
    networks.Sweet_Home_2G = {
      psk = "oh!sweethome";
    };
  };
}
