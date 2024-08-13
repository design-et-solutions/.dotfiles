{ ... }: 
{
  programs.neovim.enable = true;

  xdg.configFile = {
    "nvim/init.lua".source = ../../../custom/nvim/init.lua;
    "nvim/lua".source = ../../../custom/nvim/lua;
  };

  home.packages = with pkgs; [ 
    yarn # JavaScript package managers
  ];
}
