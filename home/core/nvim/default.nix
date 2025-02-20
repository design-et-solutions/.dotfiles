{ pkgs, ... }:
{
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.file = {
    ".scripts/nvim_reloader.fish" = {
      source = builtins.toString ../../scripts/nvim_reloader.fish;
      executable = true;
    };
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
      ${builtins.readFile ./plugins/bufferline.lua}
      ${builtins.readFile ./plugins/colorizer.lua}
      ${builtins.readFile ./plugins/conform.lua}
      ${builtins.readFile ./plugins/gruvbox.lua}
      ${builtins.readFile ./plugins/notify.lua}
      ${builtins.readFile ./plugins/nvim-tree.lua}
      ${builtins.readFile ./plugins/oil.lua}
      ${builtins.readFile ./plugins/toggleterm.lua}
      ${builtins.readFile ./plugins/tokyonight.lua}
      ${builtins.readFile ./plugins/rest-nvim.lua}
      ${builtins.readFile ./plugins/which-key.lua}
      ${builtins.readFile ./keybindings.lua}
      ${builtins.readFile ./config.lua}
    '';
    plugins =
      with pkgs.vimPlugins;
      [
        # ========================
        # misc
        # ========================
        toggleterm-nvim # floating terminal
        telescope-nvim # fuzzy finder over lists
        nvim-notify # notify
        vim-dadbod-ui # navigation database gui
        oil-nvim # file explorer that lets you edit your filesystem like a normal Neovim buffer.
        plenary-nvim # All the lua functions I don't want to write twice.
        # ========================
        # code
        # ========================
        coc-nvim # conquer of completion nvim
        coc-lua # conquer of completion lua
        coc-rust-analyzer # conquer of completion rust analyzer
        coc-tailwindcss # conquer of completion of tailwindcss
        coc-fzf # conquer of completion for fzf
        vim-nix # writing Nix expressions
        comment-nvim # comment line
        conform-nvim # formating code
        markdown-nvim # beautify markdown
        markdown-preview-nvim # preview markdown file
        nvim-lspconfig # Language Server Protocol
        rest-nvim # asynchronous Neovim HTTP client
        # rust-vim # beautify code
        # ========================
        # git
        # ========================
        vim-flog # git graph
        fugitive # git commands
        neogit # git interface
        lazygit-nvim # git interface
        # ========================
        # clean gui
        # ========================
        bufferline-nvim # tabs behavior
        which-key-nvim # displays available keybindings
        gruvbox-nvim # colorsheme
        tokyonight-nvim # colorsheme
        nvim-colorizer-lua # show color by code
        nvim-tree-lua # file explorer
        nvim-web-devicons # provide Nerd Font icons
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
              tree-sitter-http
            ]
          );
          type = "lua";
        }
      ]
      ++ [
        (pkgs.vimUtils.buildVimPlugin {
          # https://github.com/atiladefreitas/dooing
          name = "dooing"; # todo minimalist
          src = pkgs.fetchFromGitHub {
            owner = "atiladefreitas";
            repo = "dooing";
            rev = "main";
            sha256 = "sha256-E4QVGPbH+24+BzB7p2e+kzJylCcz6PBYCY68/hAOEow=";
          };
        })
      ];
  };

  home.packages = with pkgs; [
    luajit # Just-In-Time compiler for Lua programming language
    stylua # Opinionated Lua code formatter
    nixfmt-rfc-style # Formatter for Nix code following RFC style
    prettierd # Prettier daemon for faster formatting
    isort # Python utility to sort imports alphabetically
    black # The uncompromising Python code formatter
    nodePackages.prettier # Multi-language code formatter
  ];
}
