{ config, ... }:
{

  services.xserver = {
    videoDrivers = ["nvidia"];
  };

  hardware = {
    opengl.enable = true;
    nvidia = {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
