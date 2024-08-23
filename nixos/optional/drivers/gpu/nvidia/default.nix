{ config, ... }:
{
  services.xserver = {
    videoDrivers = ["nvidia"];
  };

  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
