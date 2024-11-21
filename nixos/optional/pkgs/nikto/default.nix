{ pkgs, ... }:{
  environment.systemPackages = with pkgs; [
    nikto
  ];
}

