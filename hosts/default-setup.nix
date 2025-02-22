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
    path = ./../nixos/optional/gpu;
    model = "/nvidia";
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
      isExternal = false;
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
    bluetooth = {
      enable = false;
      path = ../nixos/optional/networking/bluetooth/default.nix;
    };
  };
  vm = {
    enable = false;
    path = ../nixos/optional/vm/docker.nix;
  };
  hyprland = {
    custom = "";
  };
  autoLogin = {
    enbale = false;
    user = null;
  };
}
