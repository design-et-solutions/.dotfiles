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
  programs.hyprland = lib.mkIf isWayland {
    enable = true;
    xwayland.enable = true;
  };

  programs.hyprlock = lib.mkIf isWayland {
    enable = true;
  };

  security.pam.services = lib.mkIf isWayland {
    hyprlock = { };
  };

  services.hypridle = lib.mkIf isWayland {
    enable = true;
  };

  environment.systemPackages = lib.mkIf isWayland (
    with pkgs;
    [
      hyprcursor # Hyprland's cursor theme manager
      hyprpaper # Wallpaper utility for Hyprland
    ]
  );
}
