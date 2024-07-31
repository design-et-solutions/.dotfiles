{
  description = "Nix config";
    
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
      self,
      nixpkgs,
      home-manager,
      ...
  } @ inputs: let
      inherit (self) outputs;
  in {
    nixosConfigurations = {
      laptop-hood = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/laptop/hood
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.me = import ./modules/common/users/me;
            home-manager.extraSpecialArgs = { inherit inputs outputs; };
          }
        ];
      };
    };
  };
}