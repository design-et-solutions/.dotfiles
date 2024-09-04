{ ... }:
{
  environment.systemPackages = with pkgs; [
    can-utils
  ];

  networking.can = {
    enable = true;
    interfaces = {
      can0 = {
        bitrate = 500000;
        txqueuelen = 1000;
      };
    };
  };

}
