{ pkgs, ... }:{
  environment.systemPackages = with pkgs; [
    tshark
  ];
}

