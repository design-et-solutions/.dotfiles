{ pkgs, ... }:{
  environment.systemPackages = [
    pkgs.lynis
  ];
}

