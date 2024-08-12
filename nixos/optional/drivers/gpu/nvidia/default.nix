{ ... }:
{

  services.xserver = {
    videosDrivers = ["nvidia"];
  };

  hardware = {
    opengl.enable = true;
    nvidia.modesetting.enable = true;
  };
}
