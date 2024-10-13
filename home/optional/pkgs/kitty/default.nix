{ ... }: {
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
      shell = "tmux";
      window_padding_width = 4;
    };
    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
    };
    extraConfig = builtins.readFile ./config.conf;
  };

  xdg.configFile = {
    "kitty/light-theme.conf" = {
      source = ./light-theme.conf;
      force = true;
    };
    "kitty/dark-theme.conf" = {
      source = ./dark-theme.conf;
      force = true;
    };
  };
}
