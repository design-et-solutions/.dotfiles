{ ... }: {
  xdg.configFile = {
    "rofi/theme.rasi".source = ../../../custom/rofi/theme.rasi;
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "0xProto";
      size = 12.0;
    };
    settings = {
      shell = "tmux";
      foreground = "#e0def4";
      cursor = "#59546d";
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

      background #232136
      background_opacity 0.9
    '';
  };
}
