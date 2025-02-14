{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    htop # Interactive process viewer, an enhanced version of top
    neofetch # Fast, highly customizable system info script
  ];
}
