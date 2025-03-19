#!/usr/bin/env fish

echo "Opening LUKS device..."
cryptsetup open UUID="93d5a0ae-7b4a-4ab6-bfe7-7be9a0231632" encrypted-key
if test $status -ne 0
    echo "Failed to open LUKS device!" >&2
    exit 1
end

echo "Mounting LUKS device..."
mkdir -p /media/encrypted-key
mount /dev/mapper/encrypted-key /media/encrypted-key
if test $status -ne 0
    echo "Failed to mount filesystem!" >&2
    exit 1
end
