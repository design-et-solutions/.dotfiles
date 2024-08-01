{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    fisher.enable = true;
    # fisher.plugins = [
    #   "jorgebucaran/fisher"
    #   "PatrickF1/fzf.fish"
    #   "jethrokuan/z"
    # ];
    # Set up aliases
    # shellAliases = {
    #   ll = "ls -l";
    #   update = "sudo nixos-rebuild switch";
    # };
  };
}