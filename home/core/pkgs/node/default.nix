{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs # > npx create-next-app@latest
  ];
}
