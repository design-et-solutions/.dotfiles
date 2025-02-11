{ pkgs, lib, ... }:
{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  time.timeZone = "Europe/Paris";

  networking = {
    hostName = "r4-swr-main";
  };

  ## auto login
  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "me";
  };

  ## open nav
  systemd.services."test-web" = {
    description = "Run Firefox with a specific URL";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "me";
      ExecStart = "${pkgs.firefox}/bin/firefox http://localhost:300";
      Restart = "always";
      RestartSec = "5s";
      Environment = [
        "WAYLAND_DISPLAY=wayland-1"
        # "DISPLAY=0"
        "XDG_RUNTIME_DIR=/run/user/1000"
      ];
    };
  };
}
