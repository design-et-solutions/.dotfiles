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
    nvidia = false;
    unity = false;
    steam = false;
    steam-run = false;
    solaar = false;
    streamio = false;
    handbrake = false;
    vlc = false;
    discord = false;
    gimp = false;
    via = false;
    obs = false;
  };
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
}

