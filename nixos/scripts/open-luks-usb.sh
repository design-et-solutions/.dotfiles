#!/usr/bin/env bash

echo "Opening LUKS device..."
cryptsetup open UUID="93d5a0ae-7b4a-4ab6-bfe7-7be9a0231632" encrypted-key || {
  echo "Failed to open LUKS device!" >&2
  exit 1
}

echo "Mounting LUKS device..."
mkdir -p /media/encrypted-key
mount /dev/mapper/encrypted-key /media/encrypted-key || {
  echo "Failed to mount filesystem!" >&2
  exit 1
}
