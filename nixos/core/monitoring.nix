{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia # GPU monitoring tool for NVIDIA graphics cards
    btop # Resource monitor that shows usage and stats
    htop # Interactive process viewer, an enhanced version of top
    neofetch # Fast, highly customizable system info script
  ];
}
