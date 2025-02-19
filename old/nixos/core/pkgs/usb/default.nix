{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    usbutils       # usb cli tools
    woeusb-ng      # tool to make boot key
    ntfs3g         # ntfs
  ];
}
