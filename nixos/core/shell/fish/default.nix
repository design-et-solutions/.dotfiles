{ pkgs, ... }:
{
  programs.fish.enable = true;

  programs.fish.fisher = {
    enable = true;
  };
}
