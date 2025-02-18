{
  lib,
  pkgs,
  config,
  ...
}:
{
  programs.steam = {
    enable = true;
  };

  # environment.systemPackages = with pkgs; [
  #   flatpak
  # ];
  # xdg.portal.enable = true;

  # services.flatpak.enable = true;
  # environment.sessionVariables.XDG_DATA_DIRS = "${pkgs.flatpak}/share:/var/lib/flatpak/exports/share:/home/me/.local/share/flatpak/exports/share:$XDG_DATA_DIRS";
  # environment.sessionVariables.XDG_DATA_DIRS = "${pkgs.flatpak}/share:/var/lib/flatpak/exports/share:/home/me/.local/share/flatpak/exports/share:${config.environment.sessionVariables.XDG_DATA_DIRS}";

}
