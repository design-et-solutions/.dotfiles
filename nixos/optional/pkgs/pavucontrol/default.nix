{ pkgs, lib, ... }:{
  environment.systemPackages = with pkgs; [
    pavucontrol
  ];
}
