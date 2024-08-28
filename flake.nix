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
      hostModule, 
      system, 
      extraModules ? [],
      isGui ? false,
      users
    }: nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./nixos/core
            hostModule
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = { inherit isGui; };
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
          ] ++ extraModules;
        };
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#machine-name'
    nixosConfigurations = {
      desktop-hood = mkNixosConfiguration {
        system = "x86_64-linux";
        hostModule = ./hosts/desktop/hood;
        extraModules = [ ./nixos/optional/gui ];
        isGui = true;
        users = [ "me" ];
      };
      laptop-hood = mkNixosConfiguration {
        system = "x86_64-linux";
        hostModule = ./hosts/laptop/hood;
        extraModules = [ ./nixos/optional/gui ];
        isGui = true;
        users = [ "me" ];
      };
      desktop-work = mkNixosConfiguration {
        system = "x86_64-linux";
        hostModule = ./hosts/desktop/work;
        extraModules = [ ./nixos/optional/gui ];
        isGui = true;
        users = [ "me" "guest" ];
      };
    };
  };
}

