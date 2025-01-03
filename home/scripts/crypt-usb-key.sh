#!/usr/bin/env bash

# Unmount the USB Key
sudo umount /dev/sdb1
# Format the USB Key
sudo mkfs.ext4 /dev/sdb
# Initialize LUKS Encryption
sudo cryptsetup luksFormat /dev/sdb
# Open with name
sudo cryptsetup open /dev/sdb crypt-usb-key
# Format the Encrypted Volume
sudo mkfs.ext4 /dev/mapper/crypt-usb-key
# Mount the Encrypted Volume
sudo mount /dev/mapper/crypt-usb-key /mnt
# Unmount the encrypted volume
sudo umount /mnt
sudo cryptsetup close crypt-usb-key
