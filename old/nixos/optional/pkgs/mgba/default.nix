{ pkgs, ... }:{
  environment.systemPackages = with pkgs; [
    mgba
  ];
}
