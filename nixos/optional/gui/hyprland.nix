{
  pkgs,
  mergedSetup,
  lib,
  ...
}:
{
  programs.hyprland = lib.mkIf mergedSetup.gui.params.windowManager.hyprland {
    enable = true;
    xwayland.enable = true;
  };

  programs.hyprlock = lib.mkIf mergedSetup.gui.params.windowManager.hyprland {
    enable = true;
  };

  security.pam.services = lib.mkIf mergedSetup.gui.params.windowManager.hyprland {
    hyprlock = { };
  };

  services.hypridle = lib.mkIf mergedSetup.gui.params.windowManager.hyprland {
    enable = true;
  };

  environment.systemPackages = lib.mkIf mergedSetup.gui.params.windowManager.hyprland (
    with pkgs;
    [
      hyprcursor # Hyprland's cursor theme manager
      hyprpaper # Wallpaper utility for Hyprland
    ]
  );
}
