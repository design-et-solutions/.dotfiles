{ pkgs, lib, ... }:{
  boot.kernelModules = [ "peak_usb" ];
}
