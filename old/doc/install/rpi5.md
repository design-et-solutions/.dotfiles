Format your disk, create filesystems, and extract the Raspberry Pi UEFI EDK2 implementation to the boot entry:

```shell
disk=/dev/sda

# Erase all existing partitions on the SD card and create a new GPT partition table
sudo parted $disk mklabel gpt

# Creates a FAT32-formatted EFI System Partition (ESP) on the disk
sudo parted $disk -- mkpart ESP fat32 1MB 512MB

# Create the primary partition 512MiB (right after the previous ESP partition) and extending to the rest of the disk (100% of the remaining space)
sudo parted $disk -- mkpart primary 512MiB 100%

# Made sure to set the ESP property on the first partition
sudo parted $disk -s set 1 esp on

# Formats the first partition with a FAT32 file system named BOOT
sudo mkfs.fat -F 32 -n BOOT ${disk}1

# Formats the second partition with the ext4 file system named NIXOS
sudo mkfs.ext4 -L NIXOS ${disk}2

# Download repository contains a TF-A + EDK2 UEFI firmware port for Raspberry Pi 5
curl https://github.com/worproject/rpi5-uefi/releases/download/v0.3/RPi5_UEFI_Release_v0.3.zip --output ./RPi5_UEFI_Release_v0.3.zip

sudo mount ${disk}1 /mnt/
sudo unzip ./RPi5_UEFI_Release_v0.3.zip -d /mnt/
sudo umount
```

Flash NixOS arm64 minimial installer to USB drive:

```shell
usb-drive=/dev/sdb
curl https://channels.nixos.org/nixos-24.11/latest-nixos-minimal-aarch64-linux.iso --output ./latest-nixos-minimal-aarch64-linux.iso
sudo dd bs=4M if=./latest-nixos-minimal-aarch64-linux.iso of=${usb-drive} conv=fsync oflag=direct status=progress
```

Mount the disk:

```shell
disk=/dev/mmcblk0p
sudo mount ${disk}p2 /mnt
sudo mkdir /mnt/boot
sudo mount ${disk}p1 /mnt/boot
```

Generate and edit your config with `nixos-generate-config --root /mnt`.
You'll want to set in `/mnt/etc/nixos/configuration.nix`:

```shell
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true
  boot.loader.efi.canTouchEfiVariables = false;
```

To install the bootloader to `/EFI/` on the boot partition.
And to add the vendor kernel with e.g.:

```shell
  boot.kernelPackages = (import (builtins.fetchTarball https://gitlab.com/vriska/nix-rpi5/-/archive/main.tar.gz)).legacyPackages.aarch64-linux.linuxPackages_rpi5
```

On the Pi now, boot into the installer:

```
sudo systemctl start wpa_supplicant
wpa_cli
> add_network
0
> set_network 0 ssid "myhomenetwork"
OK
> set_network 0 psk "mypassword"
OK
> set_network 0 key_mgmt WPA-PSK
OK
> enable_network 0
OK
```

Then you can install NixOS with:

```shell
sudo nixos-install
```

Then to boot the vendor kernel, in the UEFI settings switch from ACPI to Device Tree in

```
Device Manager
-> Raspberry Pi Configuration
-> ACPI / Device Tree
-> System Table Mode
```

I also removed `force_turbo=1` from `/boot/config.txt` as suggested.

### NB

I couldn't get NixOS to boot automatically even adding the `/EFI/` file with:

```
Boot Maintenance Manager
-> Boot Options
-> Add Boot Option
-> BOOT[VenHw(<uuid>)/SD(0x0)/HD(1,GPT,<uuid>)]
-> <EFI>
-> <NixOS-boot>
-> grubaa64.efi
```

So I need to manually boot from file:

```
Boot Maintenance Manager
-> Boot Options
-> Boot From File
-> BOOT[VenHw(<uuid>)/SD(0x0)/HD(1,GPT,<uuid>)]
-> <EFI>
-> <NixOS-boot>
-> grubaa64.efi
```
