{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      la = "ls -a";
      lg = "lazygit"; 
    };
  };

  environment.systemPackages = with pkgs; [
    fish
  ];

  environment.shells = with pkgs; [ fish ];
}
