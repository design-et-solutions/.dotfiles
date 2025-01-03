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

  environment.etc."wireguard/wg0" = {
    source = builtins.toString ../../secrets/${name}/wg0;
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

  systemd.services.open-luks-usb = {
    description = "Unlock and mount LUKS-encrypted USB key";
    wantedBy = [ "multi-user.target" ]; # Start the service at boot
    after = [ "local-fs.target" ]; # Ensure filesystems are available

    serviceConfig = {
      Type = "oneshot"; # Run the commands only once
      RemainAfterExit = true; # Keep the service as "active" after execution
      ExecStart = ''
        echo "Opening LUKS device..."
        cryptsetup open UUID="93d5a0ae-7b4a-4ab6-bfe7-7be9a0231632" encrypted-key || {
          echo "Failed to open LUKS device!" >&2
          exit 1
        }

        echo "Mounting LUKS device..."
        mkdir -p /media/encrypted-key
        mount /dev/mapper/encrypted-key /media/encrypted-key || {
          echo "Failed to mount filesystem!" >&2
          exit 1
        }
      '';
    };
  };

  systemd.services.close-luks-usb = {
    description = "Unmount and close LUKS-encrypted USB key";
    wantedBy = [ "shutdown.target" ]; # Ensure it runs on shutdown
    before = [ "shutdown.target" ];  # Runs before shutdown completes

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/bin/true"; # No action on start
      ExecStop = ''
        if [ -e /dev/mapper/encrypted-key ]; then
          echo "Unmounting and closing LUKS-encrypted USB key..."
          umount /media/usb-key || {
            echo "Failed to unmount filesystem!" >&2
            exit 1
          }
          cryptsetup close encrypted-key || {
            echo "Failed to close LUKS device!" >&2
            exit 1
          }
        fi
      '';
    };
  };
}

