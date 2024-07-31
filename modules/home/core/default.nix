{ config, pkgs, ... }:
{
    imports = [];

    programs.home-manager.enable = true;

    programs.neovim.enable = true; 

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "23.05";
}