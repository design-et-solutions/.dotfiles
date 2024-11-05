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
      discord = false;
      slack = false;
    };
    tool = {
      unity = false;
      vlc = false;
      solaar = false;
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
    network = {
      wifi = {
        home = false;
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
    };
  };
}

