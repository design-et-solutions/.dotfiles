{ pkgs, lib, ... }:{
  environment.systemPackages = with pkgs; [
    steam-run # Steam env like
  ];
}
