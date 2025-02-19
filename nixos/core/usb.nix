{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    usbutils # Provides USB command-line tools (e.g., lsusb)
    woeusb-ng # Tool for creating Windows bootable USB drives from ISO images
    ntfs3g # NTFS filesystem driver and utilities for read/write support
  ];
}
