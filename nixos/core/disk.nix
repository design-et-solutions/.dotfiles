{ mergedSetup, lib, ... }:
{
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
          esp = {
            name = "ESP"; # The name of the partition, which stands for EFI System Partition.
            size = "500M";
            type = "EF00"; # The partition type for EFI System Partitions.
            content = {
              type = "filesystem";
              format = "vfat"; # The filesystem format, which is VFAT (Virtual File Allocation Table).
              mountpoint = "/boot/efi";
            };
          };
          root = {
            name = "root";
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
            size = "100%FREE"; # The size of the logical volume, which takes up all the free space in the volume group.
            content = {
              type = "filesystem";
              format = "ext4"; # The filesystem format, which is ext4, a commonly used filesystem for Linux.
              mountpoint = "/"; # The mount point for this logical volume, which is the root filesystem (/).
              mountOptions = [
                "defaults"
              ];
            };
          };
        };
      };
    };
  };
}
