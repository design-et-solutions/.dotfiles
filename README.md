# README

<h1 align="center">
  <div>
    <a href="https://github.com/YvesCousteau/config/issues">
        <img src="https://img.shields.io/github/issues/YvesCousteau/config?color=cc241d&labelColor=fbf1c7&style=for-the-badge">
    </a>
    <a href="https://github.com/YvesCousteau/config/stargazers">
        <img src="https://img.shields.io/github/stars/YvesCousteau/config?color=98971a&labelColor=fbf1c7&style=for-the-badge">
    </a>
    <a href="https://github.com/YvesCousteau/config/">
        <img src="https://img.shields.io/github/repo-size/YvesCousteau/config?color=d79921&labelColor=fbf1c7&style=for-the-badge">
    </a>
    <br>
  </div>
</h1>

## Setup

### From none setuped host

To install nixos on an none setup host or on a live CD plugged host with SSH setuped by running from a nixos host:

```sh
nixos-anywhere \
    --flake .#${name} \
     --generate-hardware-config nixos-generate-config ./hosts/${name}/hardware-configuration.nix \
    ${hostname}@${IP} -p ${SSH_PORT}
```

### From setuped host

## Self

To install nixos on an already setuped host by running from a nixos host:

```sh
sudo nixos-rebuild switch \
    --flake .#${name}
```

## On other

```sh
NIX_SSHOPTS="-p ${SSH_PORT}" nixos-rebuild switch \
    --flake .#${name} \
    --target-host ${hostname}@${IP}
```
