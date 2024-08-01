{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  nixpkgs = {
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "me";
    homeDirectory = "/home/me";
  };

  programs.neovim.enable = true;
  programs.home-manager.enable = true;
  programs.git.enable = true;

   home.packages = with pkgs; [ 
    htop
    networkmanager   
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}