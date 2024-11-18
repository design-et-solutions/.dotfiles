{ pkgs, lib, ... }:{
  environment.systemPackages = with pkgs; [
    neomutt
  ];
}
