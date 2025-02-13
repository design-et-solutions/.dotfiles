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
    eza # A modern replacement for ls
    fzf # Command-line fuzzy finder for efficient searching and filtering
    jq # Lightweight command-line JSON processor for parsing and manipulating JSON data
    nix-index # Indexes the Nix store to allow fast file lookup
    bat # A cat(1) clone with syntax highlighting and Git integration.
    starship # Minimal, blazing fast, and extremely customizable prompt for any shell
  ];
}
