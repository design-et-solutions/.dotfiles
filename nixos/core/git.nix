{ pkgs, ... }:
{
  programs.git = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    nix-prefetch-git # Utility to prefetch git repositories for Nix
    lazygit # A simple terminal UI for git commands
    git-crypt # Transparent encryption and decryption of files in a git repository (see https://github.com/AGWA/git-crypt)
    # Use 'git-crypt add-gpg-user USER_ID' to add GPG users
  ];
}
