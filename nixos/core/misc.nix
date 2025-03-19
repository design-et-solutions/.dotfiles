{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    libnotify # Library for sending desktop notifications
    unzip # Extraction utility for .zip files
    tree # Display directory structure in a tree-like format
    parted # Disk partition manipulation program
    busybox # Tiny versions of many UNIX utilities in a single executable
    grc # Generic text colorizer to enhance readability of command output
    eza # A modern replacement for ls
    fzf # Command-line fuzzy finder for efficient searching and filtering
    jq # Lightweight command-line JSON processor for parsing and manipulating JSON data
    bat # A cat(1) clone with syntax highlighting and Git integration.
    starship # Minimal, blazing fast, and extremely customizable prompt for any shell
    nodePackages.mermaid-cli # Create and modify diagrams dynamically
    imagemagick # Powerful image manipulation tool suite
    dmidecode # Tool that reads information about your system's hardware from the BIOS according to the SMBIOS/DMI standard.
  ];

  environment.etc = {
    "scripts/misc/generate_boot_key.fish" = {
      source = builtins.toString ../../scripts/misc/generate_boot_key.fish;
      mode = "0755";
    };
  };
}
