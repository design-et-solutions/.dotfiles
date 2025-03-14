# VPS

To install nixos on it:

```sh
nixos-anywhere \
    --flake .#generic \
    --generate-hardware-config nixos-facter hosts/vps-hood/facter.json \
    debian@51.75.121.66
```
