{ pkgs, lib, ... }:{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Import optional
    ../../../nixos/optional/drivers/gpu/intel
    ../../../nixos/optional/drivers/audio
    ../../../nixos/optional/drivers/bluetooth
    ../../../nixos/optional/network/wifi/home
    ../../../nixos/optional/network/can
    ../../../nixos/optional/pkgs/spotify
    ../../../nixos/optional/pkgs/python
    ../../../nixos/optional/network/can
    # Import projects
    ../../../projects/fatherhood
  ];

  time.timeZone = "Europe/Paris";

  networking= {
    hostName = "laptop-hood";
    firewall.allowedTCPPorts = lib.mkAfter [ 3000 5000 ];
  };

  environment.systemPackages = with pkgs; [
    solaar    # Linux manager for many Logitech keyboards, mice, and other devices 
    steam-run # Steam env like
  ];

  # Peak USB
  boot.kernelModules = [ "peak_usb" ];

  networking.can.interfaces = {
    can0 = {
      bitrate = 500000;
    };
    can1 = {
      bitrate = 500000;
    };
  };

}
