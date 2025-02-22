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
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs outputs; };
          modules =
            [
              ./nixos/core
              host
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  # verbose = true;
                  # useGlobalPkgs = true;
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

            ++ (
              if mergedSetup.gui.enable then
                [
                  (import mergedSetup.gui.path {
                    inherit pkgs;
                    autoLogin = mergedSetup.autoLogin;
                    inherit lib;
                  })

                ]
              else
                [ ]
            )
            ++ (if mergedSetup.gpu.enable then [ mergedSetup.gpu.path ] else [ ])
            ++ (if mergedSetup.browser.enable then [ mergedSetup.browser.path ] else [ ])
            ++ (if mergedSetup.file_explorer.enable then [ mergedSetup.file_explorer.path ] else [ ])
            ++ (if mergedSetup.mail.enable then [ mergedSetup.mail.path ] else [ ])
            ++ (if mergedSetup.print.enable then [ mergedSetup.print.path ] else [ ])
            ++ (if mergedSetup.vm.enable then [ mergedSetup.vm.path ] else [ ])
            ++ (if mergedSetup.game.steam.enable then [ mergedSetup.game.steam.path ] else [ ])
            ++ (if mergedSetup.game.mgba.enable then [ mergedSetup.game.mgba.path ] else [ ])
            ++ (
              if mergedSetup.game.xbox_controller.enable then [ mergedSetup.game.xbox_controller.path ] else [ ]
            )
            ++ (if mergedSetup.social.discord.enable then [ mergedSetup.social.discord.path ] else [ ])
            ++ (if mergedSetup.social.teams.enable then [ mergedSetup.social.teams.path ] else [ ])
            ++ (if mergedSetup.social.whatsapp.enable then [ mergedSetup.social.whatsapp.path ] else [ ])
            ++ (if mergedSetup.social.slack.enable then [ mergedSetup.social.slack.path ] else [ ])
            ++ (if mergedSetup.misc.solaar.enable then [ mergedSetup.misc.solaar.path ] else [ ])
            ++ (if mergedSetup.misc.handbrake.enable then [ mergedSetup.misc.handbrake.path ] else [ ])
            ++ (if mergedSetup.misc.gimp.enable then [ mergedSetup.misc.gimp.path ] else [ ])
            ++ (if mergedSetup.misc.vial.enable then [ mergedSetup.misc.vial.path ] else [ ])
            ++ (if mergedSetup.misc.drawio.enable then [ mergedSetup.misc.drawio.path ] else [ ])
            ++ (if mergedSetup.misc.steam-run.enable then [ mergedSetup.misc.steam-run.path ] else [ ])
            ++ (if mergedSetup.misc.streamio.enable then [ mergedSetup.misc.streamio.path ] else [ ])
            ++ (if mergedSetup.misc.unity.enable then [ mergedSetup.misc.unity.path ] else [ ])
            ++ (if mergedSetup.video.vlc.enable then [ mergedSetup.video.vlc.path ] else [ ])
            ++ (if mergedSetup.video.mpv.enable then [ mergedSetup.video.mpv.path ] else [ ])
            ++ (if mergedSetup.audio.default.enable then [ mergedSetup.audio.default.path ] else [ ])
            ++ (if mergedSetup.audio.spotify.enable then [ mergedSetup.audio.spotify.path ] else [ ])
            ++ (if mergedSetup.security.blocker.enable then [ mergedSetup.security.blocker.path ] else [ ])
            ++ (if mergedSetup.security.analyzer.enable then [ mergedSetup.security.analyzer.path ] else [ ])
            ++ (
              if mergedSetup.networking.analyzer.enable then [ mergedSetup.networking.analyzer.path ] else [ ]
            )
            ++ (
              if mergedSetup.networking.bluetooth.enable then [ mergedSetup.networking.bluetooth.path ] else [ ]
            )
            ++ (
              if mergedSetup.networking.wifi.emergency.enable then
                [ mergedSetup.networking.wifi.emergency.path ]
              else
                [ ]
            )
            ++ (
              if mergedSetup.networking.can.default.enable then
                [ mergedSetup.networking.can.default.path ]
              else
                [ ]
            )
            ++ (
              if mergedSetup.networking.can.peak.enable then [ mergedSetup.networking.can.peak.path ] else [ ]
            )
            ++ (
              if mergedSetup.networking.vpn.default.enable then
                [ mergedSetup.networking.vpn.default.path ]
              else
                [ ]
            )
            ++ (
              if mergedSetup.networking.vpn.server.enable then [ mergedSetup.networking.vpn.server.path ] else [ ]
            )
            ++ (
              if mergedSetup.networking.vpn.client.enable then
                [
                  (import mergedSetup.networking.vpn.client.path {
                    inherit pkgs;
                    isExternal = mergedSetup.networking.vpn.isExternal;
                  })
                ]
              else
                [ ]
            );
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
