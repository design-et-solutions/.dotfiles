{
  pkgs,
  lib,
  mergedSetup,
  ...
}:
{
  # https://nixos.wiki/wiki/Bootloader
  # https://mynixos.com/options/boot.loader
  boot.loader = {
    systemd-boot.enable = false;
    efi = {
      efiSysMountPoint = "/boot/efi";
      canTouchEfiVariables = true;
    };
    timeout = 10;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = false;
      useOSProber = true;
      # extraConfig = ''
      #   set superusers="root"
      #   password_pbkdf2 root grub.pbkdf2.sha512.10000.2A1FCE4064351E52A820F692C599462A720124EAC320C6BBF5F5922024588D8104F936E34A6DC797F33DF1A545A2030DD64C49C0FC279C3EF7BFF8F3179C5AD8.60B3255F4C5C695C71C5A10A043F309E9C1DD4A19E189D6AD248A8CA0660164247EF51587DC8A4E360CCEC745D6E9582C2C43E0C10086643374D75E437398142     '';
    };
  };

  disko.devices = lib.mkIf mergedSetup.disk.enable {
    disk.disk1 = {
      device = lib.mkDefault mergedSetup.disk.params.diskPath;
      type = "disk";
      content = {
        type = "gpt"; # Specifies that the partition table type is GPT (GUID Partition Table).
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02"; # The partition type, which is typically used for BIOS boot partitions.
          };
          # The partition, which stands for EFI System Partition (ESP).
          esp = {
            name = "ESP";
            size = "500M";
            type = "EF00"; # The partition type for EFI System Partitions.
            content = {
              type = "filesystem";
              format = "vfat"; # The filesystem format, which is VFAT (Virtual File Allocation Table).
              mountpoint = "/boot/efi";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "lvm_pv"; # Specifies that this partition is a physical volume for LVM (Logical Volume Manager).
              vg = "pool"; # The volume group to which this physical volume belongs, named pool.
            };
          };
        };
      };
    };
    # The root partition is part of an LVM volume group, allowing for easy resizing and management of logical volumes.
    lvm_vg = {
      pool = {
        type = "lvm_vg"; # Specifies that this is a volume group for LVM.
        lvs = {
          root = {
            size = "100%FREE - 4G"; # The size of the logical volume, which takes up all the free space in the volume group.
            content = {
              type = "filesystem";
              format = "ext4"; # The filesystem format, which is ext4, a commonly used filesystem for Linux.
              mountpoint = "/"; # The mount point for this logical volume, which is the root filesystem (/).
              mountOptions = [
                "defaults"
              ];
            };
          };
          swap = {
            size = "4G"; # Size of the swap logical volume
            content = {
              type = "swap";
            };
          };
        };
      };
    };
  };
}
