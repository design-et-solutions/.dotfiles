{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      la = "ls -a";
      lg = "lazygit"; 
      clippy-hard = "cargo clippy --all-targets --all-features -- -D warnings -W clippy::all -W clippy::restriction -W clippy::pedantic -W clippy::nursery -W clippy::cargo"; 
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
