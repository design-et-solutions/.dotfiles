# hosts/default-setup.nix
{
  gui = {
    enable = false;
    full = false;
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
      solaar = false;
      handbrake = false;
      gimp = false;
      vial = false;
      drawio = false;
      appimage = false;
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
    network = {
      vpn = {
        client = false;
        server = false;
        is_external = false;
      };
      suricata = false;
      nikto = false;
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

