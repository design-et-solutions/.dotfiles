{
  description = "Nix config with Flake and Sops";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#machine-name'
    nixosConfigurations = {
      laptop-hood = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./hosts/laptop/hood
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            users.groups.me = {};
            users.users.me = {
              group = "me";
              isNormalUser = true;
              home = "/home/me";
              shell = pkgs.fish;
            }
            home-manager.users.me = import ./home/users/me;
          }
        ];
      };
    };
  };
}
