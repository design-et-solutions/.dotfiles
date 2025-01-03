#!/usr/bin/env bash

if [ -e /dev/mapper/encrypted-key ]; then
  echo "Unmounting and closing LUKS-encrypted USB key..."
  sudo umount /media/usb-key || {
    echo "Failed to unmount filesystem!" >&2
    exit 1
  }
  sudo cryptsetup close encrypted-key || {
    echo "Failed to close LUKS device!" >&2
    exit 1
  }
fi
