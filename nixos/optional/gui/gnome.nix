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
  environment.systemPackages = lib.mkIf (!isWayland) (
    with pkgs;
    [
      gnome-tweaks
    ]
  );
}
