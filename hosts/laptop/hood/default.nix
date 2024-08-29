{ pkgs, lib, ... }:{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Import optional
    ../../../nixos/optional/drivers/gpu/intel
    ../../../nixos/optional/drivers/audio
    ../../../nixos/optional/drivers/bluetooth
    ../../../nixos/optional/network/wifi/home
    ../../../nixos/optional/pkgs/spotify
    ../../../nixos/optional/pkgs/python
  ];

  time.timeZone = "Europe/Paris";

  networking= {
    hostName = "laptop-hood";
    firewall.allowedTCPPorts = lib.mkAfter [ 3000 5000 ];
  };

  environment.systemPackages = with pkgs; [
    steam-run # Steam env like
  ];
}
