#!/usr/bin/env fish

if test -e /dev/mapper/encrypted-key
    echo "Unmounting and closing LUKS-encrypted USB key..."
    umount /media/encrypted-key
    if test $status -ne 0
        echo "Failed to unmount filesystem!" >&2
        exit 1
    end
    cryptsetup close encrypted-key
    if test $status -ne 0
        echo "Failed to close LUKS device!" >&2
        exit 1
    end
end
