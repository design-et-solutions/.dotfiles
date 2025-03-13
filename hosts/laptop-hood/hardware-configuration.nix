# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  disko.devices = {
    disk.disk1 = {
      device = "/dev/nvme0n1";
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

  # fileSystems."/" = {
  #   device = "/dev/disk/by-uuid/ce471643-cd96-4e57-9fc3-cdd08f341fa3";
  #   fsType = "ext4";
  # };
  #
  # fileSystems."/boot/efi" = {
  #   device = "/dev/disk/by-uuid/6D99-9B67";
  #   fsType = "vfat";
  #   options = [
  #     "fmask=0022"
  #     "dmask=0022"
  #   ];
  # };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usb_storage"
        "sd_mod"
        "sdhci_pci"
      ];
      kernelModules = [ "kvm-intel" ];
    };
    extraModulePackages = [ ];
  };
  swapDevices = [ ];
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
