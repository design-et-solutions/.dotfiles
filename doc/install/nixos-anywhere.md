# Nixos-anywhere

To install nixos anywhere with an OS and SSH setup:

```sh
nixos-anywhere \
    --flake .#generic \
    --generate-hardware-config nixos-facter hosts/${HOST}/facter.json \
    ${hostname}@${IP} -p ${SSH_PORT}
```
