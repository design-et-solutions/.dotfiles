{ lib, mergedSetup, ... }:
{
  disko.devices = {
    disk.disk1 = {
      device = lib.mkDefault "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          # BIOS Boot Partition for legacy GRUB (optional)
          boot = {
            name = "boot";
            size = "2M";
            type = "EF02";
          };
          # EFI System Partition (ESP) for UEFI systems
          esp = {
            name = "ESP";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "fmask=0077"
                "dmask=0077"
              ];
            };
          };
          # Root Partition setup, using LVM or LUKS based on encryption
          root =
            if !mergedSetup.disk.encryption then
              {
                name = "root";
                size = "100%"; # Use remaining space
                content = {
                  type = "lvm_pv"; # LVM Physical Volume
                  vg = "pool"; # Volume Group
                };
              }
            else
              {
                name = "cryptroot"; # Name for encrypted root partition
                size = "100%"; # Use remaining space
                content = {
                  type = "luks"; # LUKS encryption setup
                  name = "crypted"; # Name for unlocked LUKS device
                  settings.allowDiscards = true; # Enable TRIM for SSDs
                  settings.tpm2 = false; # TPM usage setting, adjust if needed
                  content = {
                    type = "lvm_pv"; # LVM Physical Volume inside LUKS
                    vg = "pool"; # Volume Group
                  };
                };
              };
        };
      };
    };
    # LVM Volume Group configuration with multiple logical volumes
    lvm_vg = {
      pool = {
        type = "lvm_vg"; # Define volume group 'pool'
        lvs = {
          # Logical Volume for the root filesystem
          root = {
            size = "50%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [
                "defaults"
                "noatime" # File system does not update the access time for files and directories
              ];
            };
          };
          # Logical Volume for user home directories
          home = {
            size = "30%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/home";
              mountOptions = [
                "defaults"
                "noatime" # File system does not update the access time for files and directories
              ];
            };
          };
          # Logical Volume for system logs, databases, etc.
          var = {
            size = "20%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/var";
              mountOptions = [
                "defaults"
                "noatime" # File system does not update the access time for files and directories
                "nodev" # Restrict device files for security
                "nosuid" # Prevent execution of setuid binaries
              ];
            };
          };
          # Logical Volume for swap partition
          swap = {
            size = "16G";
            content = {
              type = "swap";
            };
          };
        };
      };
    };
  };
}
