{ pkgs, ... }:{
  environment.systemPackages = with pkgs; [
    xpad
  ];
}
