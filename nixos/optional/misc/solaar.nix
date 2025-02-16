{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    solaar # Linux manager for many Logitech keyboards, mice, and other devices
  ];
}
