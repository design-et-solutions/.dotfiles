{ pkgs, ... }: 
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-lastplace
      rust-vim
      coc-nvim
      coc-rust-analyzer
      gruvbox-nvim
      nvim-tree-lua
      nvim-web-devicons
      {
        plugin = nvim-treesitter.withPlugins (
          plugins: with plugins; [
            tree-sitter-nix
            tree-sitter-lua
            tree-sitter-rust
            tree-sitter-c
            tree-sitter-vim
            tree-sitter-markdown
            tree-sitter-javascript
            tree-sitter-typescript
            tree-sitter-html
            tree-sitter-css
          ]
        );
        type = "lua";
      }
    ];
  };

  xdg.configFile = {
    "nvim/init.lua".source = ../../../custom/nvim/init.lua;
    "nvim/lua".source = ../../../custom/nvim/lua;
  };

  home.packages = with pkgs; [ 
    yarn # JavaScript package managers
  ];
}
