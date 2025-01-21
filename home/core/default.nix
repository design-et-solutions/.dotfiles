{ lib, mergedSetup, ... }: {
  imports = 
    (lib.optionals mergedSetup.gui.hyprland [
      ../optional/gui
    ]) ++
    [
      ./fonts
      ./pkgs/nvim
      ./pkgs/rust
      ./pkgs/git
    ];

  nixpkgs = {
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.file.".icons".source = ../icons;

  home.activation.createDirectories = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ~/work
    mkdir -p ~/perso
    mkdir -p ~/tmp
    mkdir -p ~/Screenshots
  '';

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

}
