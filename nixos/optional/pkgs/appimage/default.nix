{ pkgs, lib, ... }:{
  environment.systemPackages = with pkgs; [
    appimage-run
  ];
}
