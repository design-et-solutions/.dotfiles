{
  description = "Nix config with Flake";
  # TO CLEAR CACHE
  # sudo rm -rf /nix/var/nix/profiles/per-user/root/
  # sudo nix-collect-garbage -d

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-rpi5.url = "git+https://gitlab.com/vriska/nix-rpi5.git";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-hardware,
      nix-rpi5,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      defaultSetup = import ./hosts/default-setup.nix;
      # NixOS configuration entrypoint
      # Define a function to create a NixOS configuration
      mkNixosConfiguration =
        {
          system,
          host,
          users,
          setup,
          extraModules ? [ ],
        }:
        let
          mergedSetup = nixpkgs.lib.recursiveUpdate defaultSetup setup;
          pkgs = nixpkgs.legacyPackages.${system};
          lib = nixpkgs.lib;

          # Helper function to conditionally import modules
          importIf = condition: path: if condition then [ path ] else [ ];

          # Helper function: Recursively collect modules while keeping structure
          collectModules =
            let
              collectModulesRec =
                prefix: attrset:
                lib.flatten (
                  lib.filter (x: x != null) (
                    lib.mapAttrsToList (
                      name: value:
                      let
                        fullName = if prefix == "" then name else "${prefix}.${name}";
                      in
                      if builtins.isAttrs value then
                        if value ? enable && value ? path then
                          if value.enable then
                            builtins.trace "󰸞  ${fullName}" value.path
                          else
                            builtins.trace "󱎘  ${fullName}" null
                        else
                          collectModulesRec fullName value
                      else
                        null
                    ) attrset
                  )
                );
            in
            collectModulesRec "";

          # Generate the correctly nested structure
          optionalModules = collectModules mergedSetup;

          # Debugging: Print optionalModules
          debugOptionalModules = optionalModules;
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs outputs; };
          modules =
            let
              debugModules = builtins.trace "Final optionalModules" debugOptionalModules;
            in
            [
              (
                {
                  config,
                  pkgs,
                  lib,
                  ...
                }:
                {
                  _module.args.mergedSetup = mergedSetup;
                }
              )
              ./nixos/core
              host
              home-manager.nixosModules.home-manager
              {
                home-manager = {
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
                users.groups = nixpkgs.lib.genAttrs users (user: { });
                users.users = builtins.listToAttrs (
                  map (user: {
                    name = user;
                    value = import (./nixos/users/${user}.nix);
                  }) users
                );
              }
            ]
            ++ extraModules
            ++ debugModules
            ++ optionalModules;
        };

      nixosConfigurations = import ./hosts {
        inherit mkNixosConfiguration nixos-hardware;
        inherit (nixpkgs) lib;
      };
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#machine-name'
      inherit nixosConfigurations;
    };
}
