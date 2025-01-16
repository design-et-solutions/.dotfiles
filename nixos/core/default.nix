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

  systemd.services = {
    visionary = {
      description = "Service visionary";
      enable = true;
      wantedBy = ["multi-user.target"];
      after = [ "network.target" "tracker.service" ];
      requires = [ "tracker.service" ];
      environment = {
        WAYLAND_DISPLAY = "wayland-1";
        XDG_RUNTIME_DIR = "/run/user/1001";
        RUST_LOG = "DEBUG";
        APP_HOST = "0.0.0.0";
        TRACKER_HOST = "0.0.0.0";
        TRACKER_PORT = "50200";
      };
      serviceConfig = {
        ExecStart = "/home/me/Manager/core/visionary/target/release/visionary";
        Restart = "always";
        RestartSec = "30s";
      };
    };
    gateway = {
      description = "Service gateway";
      enable = true;
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "tracker.service" ];
      requires = [ "tracker.service" ];
      serviceConfig = {
        # ExecStart = "/home/me/Manager/core/gateway/target/release/gateway";
        ExecStart = "${pkgs.nix}/bin/nix-shell /home/me/Manager/core/gateway/nix/shell.nix --run /home/me/Manager/core/gateway/target/release/gateway";
        Restart = "always";
        RestartSec = "30s";
        Environment = [
          "RUST_LOG='DEBUG'"
          "APP_HOST='0.0.0.0'"
          "APP_PORT=8080"
          "TRACKER_HOST='0.0.0.0'"
          "TRACKER_PORT=50200"        
        ];
      };
    };
    tracker = {
      description = "Service Tracker";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "/home/me/Manager/core/tracker/target/release/registry";
        Restart = "always";
        RestartSec = "30s";
        Environment = [
          "RUST_LOG='DEBUG'"
          "APP_HOST='0.0.0.0'"
          "APP_PORT=50200"
        ];
      };
    };
    # requete = {
    #   description = "Service requete";
    #   enable = true;
    #   wantedBy = [ "multi-user.target" ];
    #   after = [ "network.target" "tracker.service" "visionary.service" "gateway.service" ];
    #   requires = [ "tracker.service" "visionary.service" "gateway.service"] ;
    #   serviceConfig = {
    #     Type = "oneshot"; # Définir le type du service comme "oneshot"
    #     ExecStart = "
    #       sleep 10s; # Attendre 10 secondes avant d'exécuter la requête
    #       curl -X POST http://localhost:8080/visionary/play/media \
    #       -H 'Content-Type: application/json'\
    #       -d '{
    #         \"service\": \"visionary\",
    #         \"monitor_index\": 1,
    #         \"media_path\": \"/home/me/Manager/example/TCPM-WELCOME1_ANIM_1_new.mp4\",
    #         \"is_looping\": false
    #       }'
    #     ";      
    #     Restart = "on-failure"; # Le service redémarrera en cas d'échec
    #     RestartSec = "30s"; # Attendre 30 secondes avant de redémarrer si le service échoue:
    #   };
    # };




    requete = {
      description = "Service requete";
      enable = true;
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "tracker.service" "visionary.service" "gateway.service" ];
      requires = [ "tracker.service" "visionary.service" "gateway.service" ];
      serviceConfig = {
        Type = "oneshot"; # Définir le type du service comme "oneshot"
        ExecStart = ''
          /bin/sh -c "sleep 10s && /run/current-system/sw/bin/curl -X POST http://localhost:8080/visionary/play/media \
            -H 'Content-Type: application/json' \
            -d '{ \
              \"service\": \"visionary\", \
              \"monitor_index\": 1, \
              \"media_path\": \"/home/me/Manager/example/TCPM-WELCOME1_ANIM_4.mp4\", \
              \"is_looping\": true \
            }'"
        '';
        Restart = "on-failure"; # Le service redémarrera en cas d'échec
        RestartSec = "30s"; # Attendre 30 secondes avant de redémarrer si le service échoue
      };
    };



  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";




#   systemd.services.display-image = {
#    description = "Display an image on startup";
#     after = [ "graphical.target" ]; # S'assurer que l'interface graphique est prête
#     wantedBy = [ "graphical.target" ];
#     serviceConfig = {
#       #ExecStart="${pkgs.bash}/bin/bash -c /home/me/start-image.sh";
#       ExecStart="/run/current-system/sw/bin/echo 'pas coucou'";
#       Restart = "always";
#       RestartSec = 5;
#       User = "me";
#       #Environment = [
#         #"DISPLAY=:0"
#         #"WAYLAND_DISPLAY=wayland-1"
#         #"PATH=${pkgs.bash}/bin:${pkgs.vlc}/bin:$PATH"
#       #];
#     };
#   };
 }
