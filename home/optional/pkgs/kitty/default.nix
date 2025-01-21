{ config, ... }:{
  imports = [
    ../tmux 
  ];

  home.sessionVariables = {
    TERMINAL = "kitty";
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 12.0;
    };
    settings = {
      shell = "${toString ./../../../scripts/tmux.fish}";
      window_padding_width = 4;
    };
    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
    };
    extraConfig = ''
      italic_font auto
      bold_font auto
      bold_italic_font auto

      include ./theme.conf
    '';
  };

  xdg.configFile."kitty/theme".source = ./theme;

  home.file = {
    ".scripts/tmux.fish" = {
      source = builtins.toString ../../../scripts/tmux.fish;
      executable = true;
    };
    ".scripts/kitty.fish" = {
      source = builtins.toString ../../../scripts/kitty.fish;
      executable = true;
    };
  };
}
