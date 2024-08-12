{
  ...
}: {
  programs.neovim = {
    enable = true;
    configure = {
      customRC = ''
        luafile ${./../../../../nvim/init.lua}
      '';
    };
  };
}
