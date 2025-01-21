# hosts/default-setup.nix
{
  gui = {
    enable = false;
    hyprland = true;
    wayfire = false;
    extra = {
      hyprland = "";
    };
    driver = {
      nvidia = false;
    };
    comm = {
      mail = false;
      discord = false;
      slack = false;
      teams = false;
      whatsapp = false;
    };
    tool = {
      unity = false;
      vlc = false;
      handbrake = false;
      gimp = false;
      vial = false;
      drawio = false;
    };
    misc = {
      steam = false;
      steam-run = false;
      streamio = false;
      mgba = false;
    };
  };
  nogui = {
    audio = {
      enable = false;
      spotify = false;
    };
    security = {
      nikto = false;
      blocky = false;
      lynis = true;
      clamav = true;
    };
    network = {
      suricata = false;
      vpn = {
        client = false;
        server = false;
        is_external = false;
      };
      wireshark = false;
      wifi = {
        emergency = false;
      };
      bluetooth = false;
      can = {
        enable = false;
        peak = false;
      };
    };
    tool = {
      solaar = false;
      docker = false;
      appimage = false;
    };
    driver = {
      print = true;
    };
    misc = {
      xbox_controller = false;
      elk = false;
    };
  };
  controller = {
    rpi5 = false;
  };
}

