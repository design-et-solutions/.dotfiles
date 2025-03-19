{
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../nixos/disk-config.nix
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMc6jbhoDuKt0YOIF9prT4reT9WG6sP2sEFVj59loQwq me@desktop-hood"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAq7LsVEV+jw4yPpLyDc4XIS2yVmSJt0J24pS4BQYtGD me@laptop-work"
  ];

  services = {
    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "me";
    };
  };

  networking = {
    hosts = {
      "192.100.1.1" = [ "cdp.thales" ];
    };
  };

  systemd.services."auto-web-1" = {
    description = "Run Firefox with a specific URL";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "me";
      ExecStart = "${pkgs.firefox}/bin/firefox --new-instance -P p1 --class firefox-1 http://localhost:3000/left";
      Restart = "always";
      RestartSec = "5s";
      Environment = [
        "DISPLAY=:0"
        "XDG_RUNTIME_DIR=/run/user/1000"
      ];
    };
  };

  systemd.services."auto-web-2" = {
    description = "Run Firefox with a specific URL";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "me";
      ExecStart = "${pkgs.firefox}/bin/firefox --new-instance -P p2 --class firefox-2 http://cdp.thales/mobile-app";
      Restart = "always";
      RestartSec = "5s";
      Environment = [
        "DISPLAY=:0"
        "XDG_RUNTIME_DIR=/run/user/1000"
      ];
    };
  };

  home-manager.users.me =
    { pkgs, ... }:
    {
      xsession.windowManager.i3.extraConfig = ''
          # Assign Firefox windows to specific workspaces
        assign [class="Firefox"] $ws1
        assign [class="Firefox" instance="firefox-2"] $ws2

        # Start Firefox on both screens
        exec --no-startup-id i3-msg 'workspace 1; exec firefox'
        exec --no-startup-id i3-msg 'workspace 2; exec firefox -P second-profile --class="firefox-2"'

        # Move workspaces to specific outputs
        workspace 1 output HDMI-1
        workspace 2 output HDMI-2
      '';
    };
}
