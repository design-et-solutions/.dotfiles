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
      mkNixosConfiguration = { hostModule, system ? "x86_64-linux" }: 
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs outputs; };
          modules = [
            hostModule
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
              };
              
              # User and group configuration for user 'me'
              users.groups.me = {};
              users.users.me = import ./nixos/users/me;
              # Home Manager configuration for user 'me'
              home-manager.users.me = import ./home/users/me;
            }
          ];
        };
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#machine-name'
    nixosConfigurations = {
      desktop-hood = mkNixosConfiguration {
        system = "x86_64-linux";
        hostModule = ./hosts/desktop/hood;
      };
      laptop-hood = mkNixosConfiguration {
        system = "x86_64-linux";
        hostModule = ./hosts/laptop/hood;
      };
    };
  };
}

