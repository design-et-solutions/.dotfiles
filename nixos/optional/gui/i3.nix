{
  pkgs,
  mergedSetup,
  lib,
  ...
}:
{
  # programs.i3 = lib.mkIf mergedSetup.gui.params.windowManager.i3 {
  #   enable = true;
  #   extraPackages = with pkgs; [
  #     i3status # Status bar
  #     i3lock # Screen locker
  #     xorg.xinit # X server initializer
  #   ];
  # };

  security.pam.services = lib.mkIf mergedSetup.gui.params.windowManager.i3 {
    i3lock = { };
  };

  services = {
    #   displayManager = lib.mkIf mergedSetup.gui.params.windowManager.i3 {
    #     defaultSession = "none+i3";
    #   };
    xserver.windowManager.i3 = lib.mkIf mergedSetup.gui.params.windowManager.i3 {
      enable = true;
      extraPackages = with pkgs; [
        i3status
        i3lock
      ];
    };

  };
  #
  # environment.pathsToLink = lib.mkIf mergedSetup.gui.params.windowManager.i3 [ "/libexec" ];
}
