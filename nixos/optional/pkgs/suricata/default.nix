{ pkgs, ... }:{
  environment.systemPackages = with pkgs; [
    suricata
  ];
}

