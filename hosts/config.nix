{
  gui = {
    enable = false;
    path = ../nixos/optional/gui;
    params = {
      displayServer = "wayland";
      hyprland = {
        custom = "";
      };
    };
  };
  device = {
    rpi5 = {
      enable = false;
      path = ../nixos/optional/controller/rpi5.nix;
    };
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
    firefox = {
      enable = false;
      path = ../nixos/optional/browser/firefox.nix;
    };
  };
  fileExplorer = {
    enable = false;
    path = ../nixos/optional/file_explorer/thunar.nix;
  };
  gpu = {
    nvidia = {
      enable = false;
      path = ./../nixos/optional/gpu/nvidia.nix;
    };
    amd = {
      enable = false;
      path = ./../nixos/optional/gpu/amd.nix;
    };
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
    gimp = {
      enable = false;
      path = ../nixos/optional/misc/gimp.nix;
    };
    handbrake = {
      enable = false;
      path = ../nixos/optional/misc/handbrake.nix;
    };
    openscad = {
      enable = false;
      path = ../nixos/optional/misc/openscad.nix;
    };
  };
  video = {
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
    internet = {
      wifi = {
        emergency = {
          enable = false;
          path = ../nixos/optional/networking/wifi/emergency.nix;
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
          params = {
            isExternal = false;
          };
        };
        server = {
          enable = false;
          path = ../nixos/optional/networking/vpn/server.nix;
        };
      };
      ssh.root.authorizedKeys = [ ];
      analyzer = {
        enable = false;
        path = ../nixos/optional/networking/analyzer.nix;
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
    bluetooth = {
      enable = false;
      path = ../nixos/optional/networking/bluetooth/default.nix;
    };
    params = {
      allowedPorts = {
        tcp = null;
        ucp = null;
      };
    };
  };
  vm = {
    docker = {
      enable = false;
      path = ../nixos/optional/vm/docker.nix;
    };
  };
}
