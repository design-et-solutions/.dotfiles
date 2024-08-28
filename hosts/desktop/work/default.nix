{ pkgs, lib, ... }:{
  imports = [
    # Import general core 
    ../default.nix
    
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Import optional
    ../../../nixos/optional/drivers/gpu/intel
    ../../../nixos/optional/pkgs/python
    ../../../nixos/optional/pkgs/steam
  ];
  
  time.timeZone = "Europe/Paris";

  networking= {
    hostName = "desktop-work";
    firewall.allowedTCPPorts = lib.mkAfter [ 5000 ];
  };

  environment.systemPackages = with pkgs; [
    steam-run # Steam env like
  ];

  services.displayManager.autoLogin = {
    enable = true;
    user = "guest";
  };

  # custom
  systemd.services.unity-front = {
    description = "Service Unity Front";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    environment = {
      WAYLAND_DISPLAY = "wayland-1";
      XDG_RUNTIME_DIR = "/run/user/1000";
    };
    serviceConfig = {
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 30";
      ExecStart = "${pkgs.steam-run}/bin/steam-run /home/guest/build.x86_64";
      Restart = "always";
      RestartSec = "30s";
    };
  };
  # systemd.services.unity-back = {
  #   description = "Service Unity Back";
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "network.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.python3.withPackages (ps: [ 
  #       ps.flask
  #       ps.flask-socketio
  #       ps.eventlet
  #       ps.colorama
  #       ps.pynput
  #     ])}/bin/python /home/guest/server.py";
  #     Restart = "always";
  #     RestartSec = "10s";
  #   };
  # };
}
