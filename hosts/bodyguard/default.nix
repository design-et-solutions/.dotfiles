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
    "scripts/open-luks-usb.sh" = {
      source = builtins.toString ../../nixos/scripts/open-luks-usb.sh;
      mode = "0755";
    };
    "scripts/close-luks-usb.sh" = {
      source = builtins.toString ../../nixos/scripts/close-luks-usb.sh;
      mode = "0755";
    };
    "wireguard/wg0" = {
      source = builtins.toString ../../secrets/${name}/wg0;
      mode = "0400";
    };
  };


  systemd.services.open-luks-usb = {
    description = "Unlock and mount LUKS-encrypted USB key";
    wantedBy = [ "multi-user.target" ]; # Start the service at boot
    after = [ "local-fs.target" ]; # Ensure filesystems are available

    serviceConfig = {
      Type = "oneshot"; # Run the commands only once
      RemainAfterExit = true; # Keep the service as "active" after execution
      ExecStart = "sudo ${pkgs.bash}/bin/bash -c '/etc/scripts/open-luks-usb.sh'";
      Environment = [
        "PATH=${pkgs.bash}/bin:${pkgs.cryptsetup}/bin:${pkgs.coreutils}/bin:${pkgs.util-linux}/bin:$PATH"
      ];
    };
  };

  systemd.services.close-luks-usb = {
    description = "Unmount and close LUKS-encrypted USB key";
    wantedBy = [ "shutdown.target" ]; # Ensure it runs on shutdown
    before = [ "shutdown.target" ];  # Runs before shutdown completes

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/bin/true"; # No action on start
      ExecStop = "sudo ${pkgs.bash}/bin/bash -c '/etc/scripts/close-luks-usb.sh'";
      Environment = [
        "PATH=${pkgs.bash}/bin:${pkgs.cryptsetup}/bin:${pkgs.coreutils}/bin:${pkgs.util-linux}/bin:$PATH"
      ];
    };
  };
}

