{ pkgs, ... }:
{
  environment.systempackages = with pkgs; [
    mgba # Game Boy Advance emulator
  ];
}
