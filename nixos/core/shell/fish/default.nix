{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    fisher.enable = true;
  };
}
