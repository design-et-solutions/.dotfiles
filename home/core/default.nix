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

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

  home.file.".shell" = {
    source = ../shell;
    force = true;
  };

  home.file.".local/share/icons" = {
    source = ../icons;
    force = true;
  };

}
