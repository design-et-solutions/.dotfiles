{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Import general core 
    ../../core

    # Import optional
    ../../optional/pkgs/git
  ];

  home = {
    username = "me";
    # homeDirectory = "/home/me";
    group = "me";
    isNormalUser = true;
    home = "/home/me";
  };

  home.packages = with pkgs; [ 
    can-utils
  ];

  # home.sessionVariables = {
  #   NIXOS_OZONE_WL = "1";
  #   WLR_NO_HARDWARE_CURSORS = "1";
  #   MOZ_ENABLE_WAYLAND = "1";
  # };
}
