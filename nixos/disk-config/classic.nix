{ lib, mergedSetup, ... }:
{
  disko.devices = {
    disk.disk1 = {
      device = lib.mkDefault "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "2M";
            type = "EF02";
          };
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
          root = {
            name = "root";
            size = "50%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [
                "defaults"
                "noatime"
              ];
            };
          };
          home = {
            name = "home";
            size = "30%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/home";
              mountOptions = [
                "defaults"
                "noatime"
              ];
            };
          };
          var = {
            name = "var";
            size = "16%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/var";
              mountOptions = [
                "defaults"
                "noatime"
                "nodev"
                "nosuid"
              ];
            };
          };
          swap = {
            name = "swap";
            size = "4%";
            content = {
              type = "swap";
              randomEncryption = true;
            };
          };
        };
      };
    };
  };
}
