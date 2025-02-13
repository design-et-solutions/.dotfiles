{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = ''
      ${builtins.readFile ./alias/misc.fish}
      ${builtins.readFile ./alias/git.fish}
      ${builtins.readFile ./alias/rust.fish}
    '';
    interactiveShellInit = ''
      ${builtins.readFile ./init.fish}
    '';
  };

  environment.systemPackages = with pkgs; [
    fish # The friendly interactive shell
    fishPlugins.done # Automatically receive notifications when long processes finish
    fishPlugins.fifc # Fzf powers on top of fish completion engine and allows customizable completion rules
    fishPlugins.fzf # Ef-fish-ient fish keybindings for fzf
    fishPlugins.grc # Generic Colouriser to add color to command output
    fishPlugins.z # Directory jumping tool that learns your habits
    fishPlugins.forgit # Utility tool powered by fzf for using git interactively
    fishPlugins.tide # A modern, powerful and flexible prompt for fish
    fishPlugins.pisces # Automagically adds matching pairs (parentheses, quotes, etc.)
    fishPlugins.sponge # Keeps your fish shell history clean from typos, incorrectly used commands and everything you don't…
    fishPlugins.fish-bd # Fish plugin to quickly go back to a parent directory up in your current working directory tree
    fishPlugins.autopair # Auto-complete matching pairs in the Fish command line
    fishPlugins.foreign-env # Foreign environment interface for Fish shell
    fishPlugins.async-prompt # Make your prompt asynchronous to improve the reactivity
    fishPlugins.plugin-sudope # Fish plugin to quickly put 'sudo' in your command
    fishPlugins.humantime-fish # Turn milliseconds into a human-readable string in Fish
    fishPlugins.colored-man-pages # Adds color to man pages for improved readability
    fishPlugins.fish-you-should-use # Fish plugin that reminds you to use your aliases

    fishPlugins.plugin-git # Git plugin for fish (similar to oh-my-zsh git)
  ];

  environment.shells = with pkgs; [ fish ];
}
