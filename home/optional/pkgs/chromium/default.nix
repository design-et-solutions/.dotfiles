{ ... }: {
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium extension ID
    ];
  };
}
