{
  description = "Nix config with Flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: 
    let inherit (self) outputs;
    # NixOS configuration entrypoint
    # Define a function to create a NixOS configuration
    mkNixosConfiguration = { 
      system,
      host,
      users,
      setup,
      extraModules
    }: nixpkgs.lib.nixosSystem {
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
                extraSpecialArgs = { inherit setup; };
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
          ++ (if setup.gui.enable then [ ./nixos/optional/gui ] else [])
          ++ (if setup.gui.nvidia then [ ./nixos/optional/drivers/gpu/nvidia ] else [])
          ++ (if setup.gui.steam then [ ./nixos/optional/pkgs/steam ] else [])
          ++ (if setup.gui.steam-run then [ ./nixos/optional/pkgs/steam ] else [])
          ++ (if setup.gui.solaar then [ ./nixos/optional/pkgs/solaar ] else [])
          ++ (if setup.gui.unity then [ ./nixos/optional/pkgs/unity ] else [])
          ++ (if setup.gui.streamio then [ ./nixos/optional/pkgs/stremio ] else [])
          ++ (if setup.gui.handbrake then [ ./nixos/optional/pkgs/handbrake ] else [])
          ++ (if setup.gui.vlc then [ ./nixos/optional/pkgs/vlc ] else [])
          # AUDIO
          ++ (if setup.audio.enable then [ ./nixos/optional/drivers/audio ] else [])
          ++ (if setup.audio.spotify then [ ./nixos/optional/pkgs/spotify ] else [])
          # NETWORK
          ++ (if setup.network.wifi.home then [ ./nixos/optional/network/wifi/home.nix ] else [])
          ++ (if setup.network.bluetooth then [ ./nixos/optional/drivers/bluetooth ] else [])
          ++ (if setup.network.can.enable then [ ./nixos/optional/network/can ] else [])
          ++ (if setup.network.can.peak then [ ./nixos/optional/network/can/peak.nix ] else []);
        };

        nixosConfigurations = import ./hosts {
          inherit mkNixosConfiguration;
          inherit (nixpkgs) lib;
        };
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#machine-name'
    inherit nixosConfigurations;
  };
}

