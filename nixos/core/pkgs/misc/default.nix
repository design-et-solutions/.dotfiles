{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    libnotify # Library for sending desktop notifications
    gcc # GNU Compiler Collection (C and C++ compilers)
    glibc # GNU C Library, the standard C library
    unzip # Extraction utility for .zip files
    tree # Display directory structure in a tree-like format
    parted # Disk partition manipulation program
    busybox # Tiny versions of many UNIX utilities in a single executable
    grc # Generic text colorizer to enhance readability of command output
  ];

  # Minimal, blazing fast, and extremely customizable prompt for any shell
  programs.starship = {
    enable = true;
  };

  # A modern replacement for ls
  programs.eza = {
    enable = true;
  };

  # Lightweight command-line JSON processor for parsing and manipulating JSON data
  programs.jq = {
    enable = true;
  };

  # Command-line fuzzy finder for efficient searching and filtering
  programs.fzf = {
    enable = true;
  };

  # Indexes the Nix store to allow fast file lookup
  programs.nix-index = {
    enable = true;
  };
}
