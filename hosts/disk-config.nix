{ lib, ... }:
{
  disko.devices = {
    disk.disk1 = {
      device = lib.mkDefault "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          # (Optional) BIOS Boot Partition (for legacy GRUB)
          boot = {
            name = "boot";
            size = "2M";
            type = "EF02";
          };
          # EFI System Partition (ESP)
          esp = {
            name = "ESP";
            size = "512M";
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
          # Root Partition (LVM Physical Volume)
          root = {
            name = "root";
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "pool";
            };
          };
        };
      };
    };
    # LVM Volume Group with multiple logical volumes
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          # Root partition (system files)
          root = {
            size = "100G";
            # size = "100%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [ "defaults" ];
            };
          };
        };
        # User home directory
        home = {
          size = "200G";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/home";
            mountOptions = [ "defaults" ];
          };
        };
        # Logs, databases, etc.
        var = {
          size = "100G";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/var";
            mountOptions = [ "defaults" ];
          };
        };
        # Dedicated swap partition
        swap = {
          size = "16G";
          content = {
            type = "swap";
          };
        };
      };
    };
  };
}
