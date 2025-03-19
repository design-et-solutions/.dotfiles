#!/usr/bin/env fish

argparse 'iso=' 'disk=' h/help -- $argv
or return

if set -q _flag_help
    echo "Usage: generate_boot_key.fish --iso=<path/to/iso> --disk=<device>"
    echo "Example: generate_boot_key.fish --iso=nixos.iso --disk=/dev/sdX"
    return 0
end

if not set -q _flag_iso; or not set -q _flag_disk
    echo "Error: Both --iso and --disk options are required."
    return 1
end

set iso_file $_flag_iso
set device $_flag_disk


echo "This will write $iso_file to $device. All data on $device will be lost!"
read -P "Are you sure? (yes/no): " confirmation

if test "$confirmation" != yes
    echo "Operation canceled."
    return 1
end

sudo dd if=$iso_file of=$device bs=4M status=progress oflag=sync

if test $status -eq 0
    echo "ISO successfully written to $device."
else
    echo "An error occurred during the process."
    return 1
end
