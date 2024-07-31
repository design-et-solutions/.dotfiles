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
      desktop-home = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./hosts/desktop/home
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.me = import ./modules/common/users/me;
          }
        ];
      };
    };
  #   # NixOS configuration entrypoint
  #   # Available through 'nixos-rebuild --flake .#hostname'
  #   nixosConfigurations = {
  #       desktop-home = nixpkgs.lib.nixosSystem {
  #           specialArgs = {inherit inputs outputs;};
  #           modules = [./hosts/desktop/home];
  #       };
  #       laptop-work = nixpkgs.lib.nixosSystem {
  #           specialArgs = {inherit inputs outputs;};
  #           modules = [./hosts/laptop/work];
  #       };
  #       server-rpi5-home = nixpkgs.lib.nixosSystem {
  #           specialArgs = {inherit inputs outputs;};
  #           modules = [./hosts/server/rpi5/home];
  #       };
  #   };

  #   # Standalone home-manager configuration entrypoint
  #   # Available through 'home-manager --flake .#username@hostname'
  #   homeConfigurations = {
  #     desktop-home = home-manager.lib.homeManagerConfiguration {
  #       system = "x86_64-linux";
  #       homeDirectory = "/home/me";
  #       username = "me";
  #       configuration = import ./hosts/desktop/home;
  #     };

  #     laptop-work = home-manager.lib.homeManagerConfiguration {
  #       system = "x86_64-linux";
  #       homeDirectory = "/home/me";
  #       username = "me";
  #       configuration = import ./hosts/laptop/work;
  #     };

  #     server-rpi5 = home-manager.lib.homeManagerConfiguration {
  #       system = "aarch64-linux";
  #       homeDirectory = "/home/root";
  #       username = "root";
  #       configuration = import ./hosts/server/rpi5/home;
  #     };
  #   };
  # };
}