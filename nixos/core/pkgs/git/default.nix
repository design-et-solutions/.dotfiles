{ pkgs, ... }: {
  programs.git = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    nix-prefetch-git
    lazygit

    # https://github.com/AGWA/git-crypt
    # git-crypt add-gpg-user USER_ID
    git-crypt
  ];
}

