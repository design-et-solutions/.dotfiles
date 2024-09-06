{ pkgs, lib, ... }:{
  environment.systemPackages = with pkgs; [
    vial
  ];
}
