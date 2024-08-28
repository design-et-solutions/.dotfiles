{ config, ... }:
{
  services.xserver = {
    videoDrivers = ["intel"];
  };
}
