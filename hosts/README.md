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

## Table of Contents

- [Themes](docs/themes/README.md)
- [Shortcuts Guide](docs/shortcuts/README.md)
- [Usage Guide](docs/usage/README.md)

## Security

### Systemd

- **CMD** => `systemd-analyze security`
- **CMD** => `systemd-analyze security <service_name>`
- **CMD** => `journactl -n 100 -fu <service_name>`
- **LINK** => `https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html`

## Print

- **CMD** => `sudo lpadmin -p name_&&_description -E -v ipp://192.168.1.XXX/ipp/print -m everywhere`

## Nix

- **LINK** => `https://nixos.org/manual/nixos/stable/`
