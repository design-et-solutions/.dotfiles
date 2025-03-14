{
  description = "Nix config with Flake";
  # TO CLEAR CACHE
  # sudo rm -rf /nix/var/nix/profiles/per-user/root/
  # sudo nix-collect-garbage -d

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-rpi5.url = "git+https://gitlab.com/vriska/nix-rpi5.git";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      inherit (self) outputs;
      config = import ./hosts/config.nix;
      # NixOS configuration entrypoint
      # Define a function to create a NixOS configuration
      mkNixosConfiguration =
        {
          system,
          users,
          hostConfig,
          name,
          extraModules ? [ ],
        }:
        let
          allUsers = users ++ [ "root" ];
          mergedSetup = nixpkgs.lib.recursiveUpdate config hostConfig;
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
                  _module.args.hostname = name;
                }
              )
              ./nixos/core
              ./hosts/${name}
              inputs.disko.nixosModules.disko
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useUserPackages = true;
                  backupFileExtension = "backup";
                  extraSpecialArgs = { inherit mergedSetup; };
                  users = nixpkgs.lib.genAttrs allUsers (user: {
                    imports = [
                      ./home/core
                      ./home/users/${user}.nix
                    ];
                  });
                };
              }
              {
                users.groups = nixpkgs.lib.genAttrs allUsers (user: { });
                users.users = builtins.listToAttrs (
                  map (user: {
                    name = user;
                    value = import (./nixos/users/${user}.nix);
                  }) allUsers
                );
              }

              inputs.nixos-facter-modules.nixosModules.facter
              {
                config.facter.reportPath =
                  if builtins.pathExists ./hosts/${name}/facter.json then
                    ./hosts/${name}/facter.json
                  else
                    throw ''
                      To FIX:
                        * Have you forgotten to run nixos-anywhere with `--generate-hardware-config nixos-facter hosts/${name}/facter.json` ?
                        * Have you forgotten to generate `./facter.json` by `sudo nixos-facter > hosts/${name}/facter.json` ?
                    '';
              }
            ]
            ++ extraModules
            ++ debugModules
            ++ optionalModules;
        };

      nixosConfigurations = import ./hosts {
        inherit mkNixosConfiguration;
        inherit (nixpkgs) lib;
      };
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#machine-name'
      inherit nixosConfigurations;
    };
}
