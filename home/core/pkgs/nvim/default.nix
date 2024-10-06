{ pkgs, ... }: 
{
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    extraConfig = builtins.readFile ./config.vim;
    extraLuaConfig = ''
      ${builtins.readFile ./config.lua}
      ${builtins.readFile ./keybindings.lua}
    '';
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      vim-nix
      vim-lastplace
      rust-vim
      coc-nvim
      coc-rust-analyzer
      gruvbox-nvim
      nvim-tree-lua
      nvim-web-devicons
      conform-nvim
      comment-nvim
      markdown-preview-nvim
      bufferline-nvim
      telescope-nvim
      toggleterm-nvim
      nvim-colorizer-lua
      fugitive
      which-key-nvim
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
}
