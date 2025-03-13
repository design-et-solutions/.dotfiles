{
  ...
}:
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/nvme0n1"; # Adjust this to match your actual device
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "nvme0n1p1";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/efi";
              };
            };
            root = {
              name = "nvme0n1p2";
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                extraArgs = [ "-F" ];
              };
            };
          };
        };
      };
    };
  };
}
