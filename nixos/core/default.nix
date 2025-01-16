{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./bootloader
    ./shell/fish
    ./pkgs/git
    ./pkgs/monitoring
    ./pkgs/network
    ./pkgs/rust
    ./pkgs/ssh
    ./pkgs/usb
    ./pkgs/mermaid
  ];

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = true;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  programs.nix-ld.enable = true; # run unpatched dynamic binaries on NixOS

  services.dbus.enable = true;   # inter-process communication (IPC), allows apps to comm with one another

  # tools and libs
  environment.systemPackages = with pkgs; [
    nix-prefetch-git

    libnotify   # notification manager
    gcc         # collection of compilers
    unzip
    tree
    websocat
    parted
    nodejs_22
    vlc
    glib
    glib.dev
    pkg-config
    gobject-introspection
  ];

  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip pkgs.gutenprint ];
  };

  #systemd.services.visionary = {
    #description = "Service visionary";
    #enable = true;
    #wantedBy = ["multi-user.target"];
    #after = [ "network.target" "SUBA-maquette-registry.service" ];
    #after = ["network.target"];
    #requires = [ "SUBA-maquette-registry.service" ];
    #environment = {
    #  WAYLAND_DISPLAY = "wayland-1";
    #  XDG_RUNTIME_DIR = "/run/user/1001";
    #};
    #serviceConfig = {
      #ExecStart = "./home/me/Manager/core/visionary/target/release/visionary";
      #ExecStart = "echo 'hello'";
      #Restart = "always";
      #RestartSec = "30s";
    #};
    # "SUBA-maquette-gateway" = {
    #   description = "Service gateway";
    #   wantedBy = [ "multi-user.target" ];
    #   after = [ "network.target" "SUBA-maquette-registry.service" ];
    #   requires = [ "SUBA-maquette-registry.service" ];
    #   serviceConfig = {
    #     #ExecStart = "${pkgs.nix}/bin/nix-shell /etc/fatherhood/shell.nix --run /etc/fatherhood/gateway";
    #     ExecStart = "./home/me/Manager/core/gateway/target/release/visionary";
    #     Restart = "always";
    #     RestartSec = "30s";
    #     #EnvironmentFile= "/etc/fatherhood/.env";
    #   };
    # };
    # "SUBA-maquette-registry" = {
    #   description = "Service Tracker";
    #   wantedBy = [ "multi-user.target" ];
    #   after = [ "network.target" ];
    #   serviceConfig = {
    #     ExecStart = "${pkgs.nix}/bin/nix-shell /home/me/Manager/core/tracker/nix/shell.nix --run 'cargo run'";
    #     Restart = "always";
    #     RestartSec = "30s";
    #     #EnvironmentFile= "/etc/fatherhood/.env";
    #   };
    # };
  #};

  systemd.services.foo = {
    enable = true;
    description = "bar";
    unitConfig = {
      Type = "simple";
    };
    serviceConfig = {
      ExecStart = "echo 'coucou'";
    };
    wantedBy = ["multi-user.target"];
  };



  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";




  #systemd.services.display-image = {
   #description = "Display an image on startup";
    #after = [ "graphical.target" ]; # S'assurer que l'interface graphique est prête
    #wantedBy = [ "graphical.target" ];
    #serviceConfig = {
      #ExecStart="${pkgs.bash}/bin/bash -c /home/me/start-image.sh";
      #Restart = "always";
      #RestartSec = 5;
      #User = "me";
      #Environment = [
        #"DISPLAY=:0"
        #"WAYLAND_DISPLAY=wayland-1"
        #"PATH=${pkgs.bash}/bin:${pkgs.vlc}/bin:$PATH"
      #];
    #};
  #};

}
