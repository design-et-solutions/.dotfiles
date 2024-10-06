{
  description = "Nix config with Flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, sops-nix, ... } @ inputs: 
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
          ++ (if mergedSetup.gui.nvidia then [ ./nixos/optional/drivers/gpu/nvidia ] else [])
          ++ (if mergedSetup.gui.steam then [ ./nixos/optional/pkgs/steam ] else [])
          ++ (if mergedSetup.gui.steam-run then [ ./nixos/optional/pkgs/steam ] else [])
          ++ (if mergedSetup.gui.solaar then [ ./nixos/optional/pkgs/solaar ] else [])
          ++ (if mergedSetup.gui.unity then [ ./nixos/optional/pkgs/unity ] else [])
          ++ (if mergedSetup.gui.streamio then [ ./nixos/optional/pkgs/stremio ] else [])
          ++ (if mergedSetup.gui.handbrake then [ ./nixos/optional/pkgs/handbrake ] else [])
          ++ (if mergedSetup.gui.vlc then [ ./nixos/optional/pkgs/vlc ] else [])
          ++ (if mergedSetup.gui.discord then [ ./nixos/optional/pkgs/discord ] else [])
          ++ (if mergedSetup.gui.gimp then [ ./nixos/optional/pkgs/gimp ] else [])
          ++ (if mergedSetup.gui.via then [ ./nixos/optional/pkgs/via ] else [])
          # AUDIO
          ++ (if mergedSetup.audio.enable then [ ./nixos/optional/drivers/audio ] else [])
          ++ (if mergedSetup.audio.spotify then [ ./nixos/optional/pkgs/spotify ] else [])
          # NETWORK
          ++ (if mergedSetup.network.wifi.home then [ ./nixos/optional/network/wifi/home.nix ] else [])
          ++ (if mergedSetup.network.wifi.emergency then [ ./nixos/optional/network/wifi/emergency.nix ] else [])
          ++ (if mergedSetup.network.bluetooth then [ ./nixos/optional/drivers/bluetooth ] else [])
          ++ (if mergedSetup.network.can.enable then [ ./nixos/optional/network/can ] else [])
          ++ (if mergedSetup.network.can.peak then [ ./nixos/optional/network/can/peak.nix ] else []);
          # MISC
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

