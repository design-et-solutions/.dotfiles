{ pkgs, lib, ... }:
let 
  name = "bodyguard";
in {
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];
  
  time.timeZone = "Europe/Paris";

  networking= {
    hostName = name;
  };

  services = {
    # ntp.enable = true;
    # ntopng = {
    #   enable = true;
    #   listenAddress = "0.0.0.0:3000";
    # };
    # suricata = {
    #   enable = true;
    #   interface = "eth0"; 
    # };
  };

  environment.etc = {
    "scripts/open-luks-usb.fish" = {
      source = builtins.toString ../../nixos/scripts/open-luks-usb.fish;
      mode = "0755";
    };
    "scripts/close-luks-usb.fish" = {
      source = builtins.toString ../../nixos/scripts/close-luks-usb.fish;
      mode = "0755";
    };
    "wireguard/wg0" = {
      source = builtins.toString ../../secrets/${name}/wg0;
      mode = "0400";
    };
  };

  systemd.services.close-luks-usb = {
    description = "Unmount and close LUKS-encrypted USB key";
    wantedBy = [ "shutdown.target" ]; # Ensure it runs on shutdown
    before = [ "shutdown.target" ];  # Runs before shutdown completes

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/true"; # No action on start
      ExecStop = "${pkgs.fish}/bin/fish -c '/etc/scripts/close-luks-usb.fish'";
      Environment = [
        "PATH=${pkgs.fish}/bin:${pkgs.cryptsetup}/bin:${pkgs.coreutils}/bin:${pkgs.util-linux}/bin:$PATH"
      ];
    };
  };
}

