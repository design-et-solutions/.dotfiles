{ ... }: 
{
  programs.neovim.enable = true;

  xdg.configFile."nvim/init.lua".text = builtins.readFile ../../../custom/nvim/init.lua;
}
