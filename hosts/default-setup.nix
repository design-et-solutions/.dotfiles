{
  gui = {
    enable = false;
    path = ../nixos/optional/gui;
  };
  rpi5 = {
    enable = false;
    path = ../nixos/optional/controller/rpi5.nix;
  };
  print = {
    enable = false;
    path = ../nixos/optional/print/default.nix;
  };
  audio = {
    default = {
      enable = false;
      path = ../nixos/optional/audio/pipewire.nix;
    };
    spotify = {
      enable = false;
      path = ../nixos/optional/audio/spotify.nix;
    };
  };
  browser = {
    enable = false;
    path = ../nixos/optional/browser/firefox.nix;
  };
  file_explorer = {
    enable = false;
    path = ../nixos/optional/file_explorer/thunar.nix;
  };
  gpu = {
    enable = false;
    path = ../nixos/optional/gpu/nvidia.nix;
  };
  mail = {
    enable = false;
    path = ../nixos/optional/mail/thunderbird.nix;
  };
  social = {
    discord = {
      enable = false;
      path = ../nixos/optional/social/discord.nix;
    };
    whatsapp = {
      enable = false;
      path = ../nixos/optional/social/whatsapp.nix;
    };
    slack = {
      enable = false;
      path = ../nixos/optional/social/slack.nix;
    };
    teams = {
      enable = false;
      path = ../nixos/optional/social/teams.nix;
    };
  };
  bluetooth = {
    enable = false;
    path = ../nixos/optional/bluetooth/default.nix;
  };
  game = {
    mgba = {
      enable = false;
      path = ../nixos/optional/game/mgba.nix;
    };
    steam = {
      enable = false;
      path = ../nixos/optional/game/steam.nix;
    };
    xbox_controller = {
      enable = false;
      path = ../nixos/optional/game/xbox_controller.nix;
    };
  };
  misc = {
    drawio = {
      enable = false;
      path = ../nixos/optional/misc/drawio.nix;
    };
    solaar = {
      enable = false;
      path = ../nixos/optional/misc/solaar.nix;
    };
    steam-run = {
      enable = false;
      path = ../nixos/optional/misc/steam_run.nix;
    };
    streamio = {
      enable = false;
      path = ../nixos/optional/misc/stremio.nix;
    };
    unity = {
      enable = false;
      path = ../nixos/optional/misc/unity.nix;
    };
    vial = {
      enable = false;
      path = ../nixos/optional/misc/vial.nix;
    };
  };
  video = {
    gimp = {
      enable = false;
      path = ../nixos/optional/video/gimp.nix;
    };
    handbrake = {
      enable = false;
      path = ../nixos/optional/video/handbrake.nix;
    };
    mpv = {
      enable = false;
      path = ../nixos/optional/video/mpv.nix;
    };
    vlc = {
      enable = false;
      path = ../nixos/optional/video/vlc.nix;
    };
  };
  security = {
    analyzer = {
      enable = false;
      path = ../nixos/optional/security/analyzer.nix;
    };
    blocker = {
      enable = false;
      path = ../nixos/optional/security/blocker.nix;
    };
  };
  networking = {
    wifi = {
      emergency = {
        enable = false;
        path = ../nixos/optional/networking/wifi/emergency.nix;
      };
    };
    can = {
      default = {
        enable = false;
        path = ../nixos/optional/networking/can/default.nix;
      };
      peak = {
        enable = false;
        path = ../nixos/optional/networking/can/peak.nix;
      };
    };
    vpn = {
      default = {
        enable = false;
        path = ../nixos/optional/networking/vpn/default.nix;
      };
      client = {
        enable = false;
        path = ../nixos/optional/networking/vpn/client.nix;
      };
      server = {
        enable = false;
        path = ../nixos/optional/networking/vpn/server.nix;
      };
    };
    analyzer = {
      enable = false;
      path = ../nixos/optional/networking/analyzer.nix;
    };
  };
  vm = {
    enable = false;
    path = ../nixos/optional/vm/docker.nix;
  };
  hyprland = {
    custom = "";
  };
}
#     tool = {
#       unity = false;
#       vlc = false;
#       handbrake = false;
#       gimp = false;
#       vial = false;
#       drawio = false;
#     };
#     misc = {
#       steam = false;
#       steam-run = false;
#       streamio = false;
#       mgba = false;
#     };
#   };
#   nogui = {
#     audio = {
#       enable = false;
#       spotify = false;
#     };
#     security = {
#       nikto = false;
#       blocky = false;
#       lynis = true;
#       clamav = true;
#     };
#     network = {
#       suricata = false;
#       vpn = {
#         client = false;
#         server = false;
#         is_external = false;
#       };
#       wireshark = false;
#       wifi = {
#         emergency = false;
#       };
#       bluetooth = false;
#       can = {
#         enable = false;
#         peak = false;
#       };
#     };
#     tool = {
#       solaar = false;
#       docker = false;
#       appimage = false;
#     };
#     driver = {
#       print = true;
#     };
#     misc = {
#       xbox_controller = false;
#       elk = false;
#     };
#   };
#   controller = {
#     rpi5 = false;
#   };
# }
#
#   # hosts/default-setup.nix
#   {
#     gui = {
#       enable = false;
#       hyprland = true;
#       wayfire = false;
#       extra = {
#         hyprland = "";
#       };
#       driver = {
#         nvidia = false;
#       };
#       comm = {
#         mail = false;
#         discord = false;
#         slack = false;
#         teams = false;
#         whatsapp = false;
#       };
#       tool = {
#         unity = false;
#         vlc = false;
#         handbrake = false;
#         gimp = false;
#         vial = false;
#         drawio = false;
#       };
#       misc = {
#         steam = false;
#         steam-run = false;
#         streamio = false;
#         mgba = false;
#       };
#     };
#     nogui = {
#       audio = {
#         enable = false;
#         spotify = false;
#       };
#       security = {
#         nikto = false;
#         blocky = false;
#         lynis = true;
#         clamav = true;
#       };
#       network = {
#         suricata = false;
#         vpn = {
#           client = false;
#           server = false;
#           is_external = false;
#         };
#         wireshark = false;
#         wifi = {
#           emergency = false;
#         };
#         bluetooth = false;
#         can = {
#           enable = false;
#           peak = false;
#         };
#       };
#       tool = {
#         solaar = false;
#         docker = false;
#         appimage = false;
#       };
#       driver = {
#         print = true;
#       };
#       misc = {
#         xbox_controller = false;
#         elk = false;
#       };
#     };
#     controller = {
#       rpi5 = false;
#     };
#   }
