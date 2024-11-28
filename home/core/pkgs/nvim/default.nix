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
    extraConfig = ''
      ${builtins.readFile ./config.vim}
      set shadafile=~/.local/share/nvim/custom.shada
    '';
    extraLuaConfig = ''
      ${builtins.readFile ./config.lua}
      ${builtins.readFile ./plugins/bufferline.lua}
      ${builtins.readFile ./plugins/colorizer.lua}
      ${builtins.readFile ./plugins/gruvbox.lua}
      ${builtins.readFile ./plugins/image.lua}
      ${builtins.readFile ./plugins/nvim-tree.lua}
      ${builtins.readFile ./plugins/rest-nvim.lua}
      ${builtins.readFile ./plugins/toggleterm.lua}
      ${builtins.readFile ./plugins/tokyonight.lua}
      ${builtins.readFile ./plugins/which-key.lua}
      ${builtins.readFile ./keybindings.lua}
    '';
    extraPackages = with pkgs; [
      luajit
      imagemagick
      postgresql
    ];
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/vim-plugin-names
    plugins = with pkgs.vimPlugins; [
      bufferline-nvim         # https://github.com/akinsho/bufferline.nvim
      coc-nvim                # https://github.com/neoclide/coc.nvim
      coc-lua                 # https://github.com/josa42/coc-lua
      coc-rust-analyzer       # ...
      coc-tailwindcss         # https://github.com/iamcco/coc-tailwindcss
      coc-fzf                 # https://github.com/antoinemadec/coc-fzf
      comment-nvim            # https://github.com/numtostr/comment.nvim
      conform-nvim            # https://github.com/stevearc/conform.nvim
      fugitive                # https://github.com/tpope/vim-fugitive (git)
      gruvbox-nvim            # https://github.com/ellisonleao/gruvbox.nvim
      image-nvim              # https://github.com/samodostal/image.nvim
      markdown-nvim           # https://github.com/tadmccorkle/markdown.nvim
      markdown-preview-nvim   # https://github.com/iamcco/markdown-preview.nvim
      nvim-colorizer-lua      # https://github.com/nvchad/nvim-colorizer.lua
      nvim-lspconfig          # https://github.com/neovim/nvim-lspconfig
      nvim-tree-lua           # https://github.com/nvim-tree/nvim-tree.lua
      nvim-web-devicons       # https://github.com/nvim-tree/nvim-web-devicons
      rest-nvim               # https://github.com/rest-nvim/rest.nvim
      rust-tools-nvim         # https://github.com/simrat39/rust-tools.nvim
      rust-vim                # https://github.com/rust-lang/rust.vim
      telescope-coc-nvim      # https://github.com/fannheyward/telescope-coc.nvim
      telescope-nvim          # https://github.com/nvim-telescope/telescope.nvim
      toggleterm-nvim         # https://github.com/akinsho/toggleterm.nvim
      tokyonight-nvim         # https://github.com/folke/tokyonight.nvim
      vim-dadbod              # https://github.com/tpope/vim-dadbod
      vim-dadbod-completion   # https://github.com/kristijanhusak/vim-dadbod-completion
      vim-dadbod-ui           # https://github.com/kristijanhusak/vim-dadbod-ui
      vim-nix                 # https://github.com/LnL7/vim-nix
      vim-lastplace           # https://github.com/ethanholz/nvim-lastplace
      which-key-nvim          # https://github.com/liuchengxu/vim-which-key
      {
        # https://github.com/nvim-treesitter/nvim-treesitter
        plugin = nvim-treesitter.withPlugins (
          plugins: with plugins; [
            tree-sitter-bash
            tree-sitter-c
            tree-sitter-cmake
            tree-sitter-css
            tree-sitter-gitignore
            tree-sitter-html          
            tree-sitter-javascript    
            tree-sitter-json   
            tree-sitter-latex   
            tree-sitter-lua  
            tree-sitter-markdown      
            tree-sitter-markdown_inline      
            tree-sitter-mermaid      
            tree-sitter-nix           
            tree-sitter-proto           
            tree-sitter-python           
            tree-sitter-rust          
            tree-sitter-sql          
            tree-sitter-toml          
            tree-sitter-typescript    
            tree-sitter-vim           
            tree-sitter-vimdoc           
            tree-sitter-yaml           
          ]
        );
        type = "lua";
      }
    ];
  };

  home.packages = with pkgs; [
    ripgrep
  ];
}
