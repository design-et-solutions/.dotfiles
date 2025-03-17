{
  pkgs,
  mergedSetup,
  lib,
  ...
}:
{
  services.xserver = {
    displayManager = lib.mkIf mergedSetup.gui.params.windowManager.i3 {
      defaultSession = "none+i3";
    };
    windowManager.i3 = lib.mkIf mergedSetup.gui.params.windowManager.i3 {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
      ];
    };
  };

  environment.pathsToLink = lib.mkIf mergedSetup.gui.params.windowManager.i3 [ "/libexec" ];
}
