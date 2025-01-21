{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      # MISC
      ll = "ls -l";
      la = "ls -a";

      # GITHUB
      gh = "lazygit"; 
      gh-reset-last-commit= "git commit --amend";
      gh-stash = "git stash";
      gh-stash-back = "git stash pop";
      gh-tag = "git tag";
      
      # RUST
      clippy-full = "cargo clippy --all-targets --all-features -- -D warnings -W clippy::all -W clippy::pedantic -W clippy::nursery -W clippy::perf -W clippy::complexity -W clippy::suspicious -W clippy::style -W clippy::correctness"; 
      # all lints that are on by default (correctness, suspicious, style, complexity, perf)
      clippy-all = "cargo clippy --all-targets --all-features -- -D warnings -W clippy::all"; 
      # lints for the cargo manifest
      clippy-cargo = "cargo clippy --all-targets --all-features -- -D warnings -W clippy::cargo"; 
      # new lints that are still under development
      clippy-nursery = "cargo clippy --all-targets --all-features -- -D warnings -W clippy::nursery"; 
      # lints which are rather strict or have occasional false positives
      clippy-pedantic = "cargo clippy --all-targets --all-features -- -D warnings -W clippy::pedantic"; 
      # code that can be written to run faster
      clippy-perf = "cargo clippy --all-targets --all-features -- -D warnings -W clippy::perf"; 
      # lints which prevent the use of language and library features1
      clippy-restriction = "cargo clippy --all-targets --all-features -- -D warnings -W clippy::restriction"; 
      # code that does something simple but in a complex way
      clippy-complexity = "cargo clippy --all-targets --all-features -- -D warnings -W clippy::complexity"; 
      # code that should be written in a more idiomatic way
      clippy-style = "cargo clippy --all-targets --all-features -- -D warnings -W clippy::style"; 
      # code that is most likely wrong or useless
      clippy-suspicious = "cargo clippy --all-targets --all-features -- -D warnings -W clippy::suspicious"; 
      # code that is outright wrong or useless
      clippy-correctness = "cargo clippy --all-targets --all-features -- -D warnings -W clippy::correctness"; 
      cargo-check-udeps = "rustup run nightly cargo udeps --all-targets  --all-features"; 
      cargo-tree-search = "cargo tree -i ";
    };
    interactiveShellInit = ''
      starship init fish | source
      fish_vi_key_bindings

      if not set -q THEME
          set -xU THEME gruvbox-light
      end

      fzf --fish | source
    '';
  };

  programs.starship = {
    enable = true;
  };


  environment.systemPackages = with pkgs; [
    fish
    starship
    fishPlugins.done # Automatically receive notifications when long processes finish
    fishPlugins.fzf-fish # Augment your fish command line with fzf key bindings
    fishPlugins.forgit # Utility tool powered by fzf for using git interactively
    fzf
    fishPlugins.grc
    grc
  ];

  environment.shells = with pkgs; [ fish ];
}
