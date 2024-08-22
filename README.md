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
 ├─ Whatsapp
 ╰─ Discord
```

### Color Theme 

<a href="https://github.com/morhetz/gruvbox">
    <img src="https://camo.githubusercontent.com/fb51e4d6818d41160c5b181693947541c36c22cb2172e8f323386f5bfd07b089/687474703a2f2f692e696d6775722e636f6d2f3439714b7959572e706e67"/>
</a>

---

<details><summary><h3>Commands</h3></summary>

> [!IMPORTANT]
> rebuil nixos by (need root permisions): 
> ```sh
> > nixos-rebuild switch --flake .#{host}
> ```

> [!IMPORTANT]
> rebuil nixos by (need root permisions): 
> ```sh
> > nixos-rebuild switch --flake .#{host}
> ```


</details>
---
<details>
<summary><h2>Shortcuts</h2></summary>

### Table of Contents
- [Hyprland Shortcuts](#hyprland-shortcuts)
- [Neovim Shortcuts](#neovim-shortcuts)
- [Tmux Shortcuts](#tmux-shortcuts)
- [Audio Shortcuts](#audio-shortcuts)
- [Bluetooth Shortcuts](#bluetooth-shortcuts)
- [Kitty Shortcuts](#kitty-shortcuts)

### Hyprland Shortcuts

#### General Shortcuts
| Shortcut                | Action                               |
|-------------------------|--------------------------------------|
| `Super + l`             | lock screen                          |
| `Super + t`             | open terminal                        |
| `Super + e`             | open file manager                    |
| `Super + d`             | open menu                            |
| `Super + q`             | kill active panel                    |
| `Super + Shift + q`     | exit                                 |
| `Super + f`             | fulll screen panel                   |

#### Mouvement Shortcuts
| Shortcut                | Action                               |
|-------------------------|--------------------------------------|
| `Super + h`             | focus left panel                     |
| `Super + j`             | focus bottom panel                   |
| `Super + k`             | focus top panel                      |
| `Super + l`             | focus right panel                    |
| `Super + Shift + h`     | focus left window                    |
| `Super + Shift + l`     | focus right window                   |
| `Super + [0-9]`         | focus to specified window       |

#### Mouve Shortcuts
| Shortcut                | Action                               |
|-------------------------|--------------------------------------|
| `Super + Shift + [0-9]` | move panel to specified window       |

### Neovim Shortcuts

#### Mouvement Shortcuts
| Shortcut                | Action                               |
|-------------------------|--------------------------------------|
| `Ctrl + h`              | focus left window                    |
| `Ctrl + j`              | focus bottom window                  |
| `Ctrl + k`              | focus top window                     |
| `Ctrl + l`              | focus right window                   |

#### Buffer Shortcuts
| Shortcut                | Action                               |
|-------------------------|--------------------------------------|
| `Alt + q`               | close current buffer                 |
| `Alt + s`               | save current buffer                  |
| `Tab`                   | goto next buffer                     |
| `Shift + Tab`           | goto previous buffer                 |
| `Alt + b`               | list buffers                         |

#### Split Shortcuts
| Shortcut                | Action                               |
|-------------------------|--------------------------------------|
| `Alt + v`               | split window horizontally            |
| `Alt + h`               | split window vertically              |

#### Comment Shortcuts
| Shortcut                | Action                               |
|-------------------------|--------------------------------------|
| `Alt + c`               | Comment line(s)                      |
#### Tree Shortcuts
| Shortcut                | Action                               |
|-------------------------|--------------------------------------|
| `Alt + n`               | Toggle Tree                          |
| `Alt + t`               | Focus Tree                           |
| `Alt + r`               | Refresh Tree                         |

### Tmux Shortcuts

#### General Shortcuts
| Shortcut                | Action                               |
|-------------------------|--------------------------------------|
| `Ctrl + f + c`          | new window                           |

#### Split Shortcuts
| Shortcut                | Action                               |
|-------------------------|--------------------------------------|
| `Ctrl + f + h`          | split panel horizontally             |
| `Ctrl + f + v`          | split panel vertically               |

#### Mouvement Shortcuts
| Shortcut                | Action                               |
|-------------------------|--------------------------------------|
| `Ctrl + f + Shift + h`  | focus left panel                     |
| `Ctrl + f + Shift + j`  | focus bottom panel                   |
| `Ctrl + f + Shift + k`  | focus top panel                      |
| `Ctrl + f + Shift + l`  | focus right panel                    |
| `Ctrl + f + Shift + a`  | toggle current and previous window   |

### Audio Shortcuts
| Shortcut                | Action                               |
|-------------------------|--------------------------------------|

### Bluetooth Shortcuts
| Shortcut                | Action                               |
|-------------------------|--------------------------------------|

### Kitty Shortcuts
| Shortcut                | Action                               |
|-------------------------|--------------------------------------|
| `Ctrl + Shift + c`      | copy to clickboard                   |
| `Ctrl + Shift + v`      | past to clickboard                   |

</details>
