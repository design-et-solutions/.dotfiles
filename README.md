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

```mint
 ╭─ Distro          -> NixOS
 ├─ Editor          -> NeoVim
 ├─ Browser         -> Firefox
 ├─ Mail            -> 
 ├─ Shell           -> Fish
 │  ╰─ Prompt       -> Starship
 ├─ WM              -> Hyprland
 │  ├─ Bar          -> Waybar
 │  ├─ Login        -> 
 │  ├─ Lock         -> 
 │  ├─ App Menu     -> Rofi
 │  ├─ Notification -> 
 │  ├─ File Manager -> 
 │  ╰─ Wallpaper    -> Hyprpaper
 ├─ Theme           -> Gruvbox Light
 ├─ Audio           -> 
 ├─ Project Manager -> Git 
 │  ╰─ TUI          -> Lazygit
 ├─ Terminal        -> Kitty
 │  ╰─ Multiplexer  -> Tmux
 ╰─ Font            -> FiraCode
```

### App

```
 ╭─ Steam
 ├─ Vial
 ├─ Unity
 ╰─ Streamio
```

## Table of Contents

- [Themes](docs/themes/README.md)
- [Shortcuts Guide](docs/shortcuts/README.md)
- [Usage Guide](docs/usage/README.md)

## For blind man
If you only need it occasionally on a specific user so:
> `./home/optional/`

If you need it always on a specific user so:
> `./home/users/${user}`

If you only need it always on all users so:
> `./home/core/`

If you only need it occasionally on a specific host so:
> `./nixos/optional/`

If you need it always on a specific host so:
> `./hosts/${host}`

If you only need it always on all hosts so:
> `./nixos/core/`

> [!TIP]
> to update `home-manager` rebuild your `kernel` and `logout` 

> [!TIP]
> to update `nixios` rebuild your `kernel` and smile 

> [!TIP]
> to update `hyprl` rebuild your `kernel` and run `hyprlctl reload` 

> [!TIP]
> to update `waybar` rebuild your `kernel` and smile 

# Links
* https://fedoraproject.org/wiki/Changes/SystemdSecurityHardening
