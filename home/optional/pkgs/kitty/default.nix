{ ... }: {
  programs.kitty = {
    enable = true;
    font = "0xProto";
    fontSize = 12.0;
    foreground = "#e0def4";
    background = "#232136";
    cursor = "#59546d";
    backgroundOpacity = 0.9;
    windowPaddingWidth = 4;
    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
    };
    extraConfig = ''
      italic_font auto
      bold_font auto
      bold_italic_font auto
    '';
  };
}
