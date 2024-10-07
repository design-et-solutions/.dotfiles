{ pkgs, ... }: 
{
  programs.git = {
    enable = true;
    extraConfig = {
      pull = {
        rebase = false;
        merge = true;
      };
    };
  };
}
