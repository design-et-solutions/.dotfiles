{
  pkgs,
  mergedSetup,
  lib,
  ...
}:
let
  isWayland = mergedSetup.gui.params.displayServer == "wayland";
in
{
  programs.dconf = lib.mkIf isWayland {
    enable = true;
  };

  environment.systemPackages =
    lib.mkIf (!isWayland) (
      with pkgs;
      [
        gnome-photos
        gnome-tour
      ]
    )
    ++ (with pkgs.gnome; [
      cheese
      gnome-music
      gedit
      epiphany
      geary
      gnome-characters
      tali
      iagno
      hitori
      atomix
      yelp
      gnome-contacts
      gnome-initial-setup
    ]);
}
