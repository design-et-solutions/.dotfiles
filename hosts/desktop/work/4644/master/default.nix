{ pkgs, lib, ... }:{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Import optional
    ../../../../../nixos/optional/drivers/gpu/intel
  ];

  time.timeZone = "Europe/Paris";
  
  networking= {
    hostName = "desktop-work-4644-master";
    firewall.allowedTCPPorts = lib.mkAfter [ 3000 ];
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "guest";
  };

  # systemd.services. = {
  #   description = "Service Unity Front";
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "network.target" ];
  #   environment = {
  #     WAYLAND_DISPLAY = "wayland-1";
  #     XDG_RUNTIME_DIR = "/run/user/1001";
  #   };
  #   serviceConfig = {
  #     ExecStartPre = "${pkgs.coreutils}/bin/sleep 30";
  #     ExecStart = "${pkgs.steam-run}/bin/steam-run /home/guest/build.x86_64";
  #     Restart = "always";
  #     RestartSec = "30s";
  #   };
  # };
}
