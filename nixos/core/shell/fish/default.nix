{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      la = "ls -a";
      lg = "lazygit"; 
    };
    interactiveShellInit = ''
      starship init fish | source
    '';
  };

  programs.starship = {
    enable = true;
  };


  environment.systemPackages = with pkgs; [
    fish
    starship
  ];

  environment.shells = with pkgs; [ fish ];
}
