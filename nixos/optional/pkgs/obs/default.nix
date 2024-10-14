{ pkgs, lib, ... }:{
  environment.systemPackages = with pkgs; [
    obs-studio
  ];
}
