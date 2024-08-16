{
  ...
}: {
  programs.tmux.enable = true;

  home.file = {
    ".tmux.conf".source = ../../custom/tmux/tmux.conf;
  }; 
}
