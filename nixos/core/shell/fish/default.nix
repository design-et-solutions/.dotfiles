{ pkgs, ... }:
{
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    fish
  ];

  environment.shells = with pkgs; [ fish ]
}
