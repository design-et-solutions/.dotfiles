{
  description = "Nix config with Flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";
    nix-rpi5.url = "git+https://gitlab.com/vriska/nix-rpi5.git";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { 
    self, 
    nixpkgs, 
    home-manager, 
    nixos-hardware, 
    sops-nix, 
    rust-overlay, 
    nix-rpi5,
    ... 
  } @ inputs: 
    let inherit (self) outputs;
    defaultSetup = import ./hosts/default-setup.nix;
    # NixOS configuration entrypoint
    # Define a function to create a NixOS configuration
    mkNixosConfiguration = { 
      system,
      host,
      users,
      setup,
      extraModules ? []
    }: 
    let
      mergedSetup = nixpkgs.lib.recursiveUpdate defaultSetup setup;
      pkgs = nixpkgs.legacyPackages.${system};
    in
    nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/core
            host
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                # verbose = true;
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = { inherit mergedSetup; };
                users = nixpkgs.lib.genAttrs users (user: {
                  imports = [
                    ./home/core
                    ./home/users/${user}.nix
                  ];
                });
              };
            }
            {
              users.groups = nixpkgs.lib.genAttrs users (user: {});
              users.users = builtins.listToAttrs (map (user: {
                name = user;
                value = import (./nixos/users/${user}.nix);
              }) users);
            }
          ] 
          ++ extraModules

          # GUI
          ++ (if mergedSetup.gui.enable then [ ./nixos/optional/gui ] else [])
          ++ (if mergedSetup.gui.hyprland then [ ./nixos/optional/gui/hyprland.nix ] else [])
          ++ (if mergedSetup.gui.wayfire then [ ./nixos/optional/gui/wayfire.nix ] else [])
          #   DRIVER
          ++ (if mergedSetup.gui.driver.nvidia then [ ./nixos/optional/drivers/gpu/nvidia ] else [])
          #   COMM
          ++ (if mergedSetup.gui.comm.discord then [ ./nixos/optional/pkgs/discord ] else [])
          ++ (if mergedSetup.gui.comm.slack then [ ./nixos/optional/pkgs/slack ] else [])
          ++ (if mergedSetup.gui.comm.teams then [ ./nixos/optional/pkgs/teams ] else [])
          ++ (if mergedSetup.gui.comm.whatsapp then [ ./nixos/optional/pkgs/whatsapp ] else [])
          ++ (if mergedSetup.gui.comm.mail then [ ./nixos/optional/pkgs/mail ] else [])
          #   TOOL
          ++ (if mergedSetup.gui.tool.solaar then [ ./nixos/optional/pkgs/solaar ] else [])
          ++ (if mergedSetup.gui.tool.unity then [ ./nixos/optional/pkgs/unity ] else [])
          ++ (if mergedSetup.gui.tool.handbrake then [ ./nixos/optional/pkgs/handbrake ] else [])
          ++ (if mergedSetup.gui.tool.vlc then [ ./nixos/optional/pkgs/vlc ] else [])
          ++ (if mergedSetup.gui.tool.gimp then [ ./nixos/optional/pkgs/gimp ] else [])
          ++ (if mergedSetup.gui.tool.vial then [ ./nixos/optional/pkgs/vial ] else [])
          ++ (if mergedSetup.gui.tool.drawio then [ ./nixos/optional/pkgs/drawio ] else [])
          #   MISC
          ++ (if mergedSetup.gui.misc.steam then [ ./nixos/optional/pkgs/steam ] else [])
          ++ (if mergedSetup.gui.misc.steam-run then [ ./nixos/optional/pkgs/steam ] else [])
          ++ (if mergedSetup.gui.misc.streamio then [ ./nixos/optional/pkgs/stremio ] else [])
          ++ (if mergedSetup.gui.misc.mgba then [ ./nixos/optional/pkgs/mgba ] else [])

          # NOGUI
          #   AUDIO
          ++ (if mergedSetup.nogui.audio.enable then [ ./nixos/optional/drivers/audio ] else [])
          ++ (if mergedSetup.nogui.audio.spotify then [ ./nixos/optional/pkgs/spotify ] else [])
          #   NETWORK
          ++ (if mergedSetup.nogui.network.vpn.server then [ ./nixos/optional/network/vpn/server.nix ] else [])
          ++ (if mergedSetup.nogui.network.vpn.client then [ 
            (import ./nixos/optional/network/vpn/client.nix { 
              inherit pkgs;
              is_external = mergedSetup.nogui.network.vpn.is_external; 
            }) 
          ] else [])          
          ++ (if mergedSetup.nogui.network.suricata then [ ./nixos/optional/pkgs/suricata ] else [])
          ++ (if mergedSetup.nogui.network.nikto then [ ./nixos/optional/pkgs/nikto ] else [])
          ++ (if mergedSetup.nogui.network.wireshark then [ ./nixos/optional/pkgs/wireshark ] else [])
          ++ (if mergedSetup.nogui.network.wifi.emergency then [ ./nixos/optional/network/wifi/emergency.nix ] else [])
          ++ (if mergedSetup.nogui.network.bluetooth then [ ./nixos/optional/drivers/bluetooth ] else [])
          ++ (if mergedSetup.nogui.network.can.enable then [ ./nixos/optional/network/can ] else [])
          ++ (if mergedSetup.nogui.network.can.peak then [ ./nixos/optional/network/can/peak.nix ] else [])
          #   DRIVER
          ++ (if mergedSetup.nogui.driver.print then [ ./nixos/optional/drivers/print ] else [])
          #   MISC
          ++ (if mergedSetup.nogui.misc.xbox_controller then [ ./nixos/optional/pkgs/xbox_controller ] else [])
          ++ (if mergedSetup.nogui.misc.elk then [ ./nixos/optional/pkgs/elk ] else [])

          # CONTROLLER
          ++ (if mergedSetup.controller.rpi5 then [ ./nixos/optional/controller/rpi5 ] else []);
        };

        nixosConfigurations = import ./hosts {
          inherit mkNixosConfiguration nixos-hardware;
          inherit (nixpkgs) lib;
        };
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#machine-name'
    inherit nixosConfigurations;
  };
}

