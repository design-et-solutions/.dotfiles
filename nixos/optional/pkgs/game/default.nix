{ pkgs, ... }:{
  environment.systemPackages = with pkgs; [
    fuse
    libfuse
  ];
}
