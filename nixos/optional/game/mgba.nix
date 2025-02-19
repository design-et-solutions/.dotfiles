{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mgba # Game Boy Advance emulator
  ];
}
