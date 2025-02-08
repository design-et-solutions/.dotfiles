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

            # GUI
            ++ (if mergedSetup.gui.enable then [ ./nixos/optional/gui ] else [ ])
            ++ (if mergedSetup.gui.hyprland then [ ./nixos/optional/gui/hyprland.nix ] else [ ])
            ++ (if mergedSetup.gui.wayfire then [ ./nixos/optional/gui/wayfire.nix ] else [ ])
            #   DRIVER
            ++ (if mergedSetup.gui.driver.nvidia then [ ./nixos/optional/drivers/gpu/nvidia ] else [ ])
            #   COMM
            ++ (if mergedSetup.gui.comm.discord then [ ./nixos/optional/pkgs/comm/discord ] else [ ])
            ++ (if mergedSetup.gui.comm.slack then [ ./nixos/optional/pkgs/comm/slack ] else [ ])
            ++ (if mergedSetup.gui.comm.teams then [ ./nixos/optional/pkgs/comm/teams ] else [ ])
            ++ (if mergedSetup.gui.comm.whatsapp then [ ./nixos/optional/pkgs/comm/whatsapp ] else [ ])
            ++ (if mergedSetup.gui.comm.mail then [ ./nixos/optional/pkgs/comm/mail ] else [ ])
            #   TOOL
            ++ (if mergedSetup.gui.tool.drawio then [ ./nixos/optional/pkgs/tool/drawio ] else [ ])
            ++ (if mergedSetup.gui.tool.gimp then [ ./nixos/optional/pkgs/tool/gimp ] else [ ])
            ++ (if mergedSetup.gui.tool.handbrake then [ ./nixos/optional/pkgs/tool/handbrake ] else [ ])
            ++ (if mergedSetup.gui.misc.steam-run then [ ./nixos/optional/pkgs/tool/steam-run ] else [ ])
            ++ (if mergedSetup.gui.tool.unity then [ ./nixos/optional/pkgs/tool/unity ] else [ ])
            ++ (if mergedSetup.gui.tool.vial then [ ./nixos/optional/pkgs/tool/vial ] else [ ])
            ++ (if mergedSetup.gui.tool.vlc then [ ./nixos/optional/pkgs/tool/vlc ] else [ ])
            #   MISC
            ++ (if mergedSetup.gui.misc.steam then [ ./nixos/optional/pkgs/misc/steam ] else [ ])
            ++ (if mergedSetup.gui.misc.streamio then [ ./nixos/optional/pkgs/misc/stremio ] else [ ])
            ++ (if mergedSetup.gui.misc.mgba then [ ./nixos/optional/pkgs/misc/mgba ] else [ ])

            # NOGUI
            #   TOOL
            ++ (if mergedSetup.nogui.tool.appimage then [ ./nixos/optional/pkgs/tool/appimage ] else [ ])
            ++ (if mergedSetup.nogui.tool.docker then [ ./nixos/optional/pkgs/tool/docker ] else [ ])
            ++ (if mergedSetup.nogui.tool.solaar then [ ./nixos/optional/pkgs/tool/solaar ] else [ ])
            #   AUDIO
            ++ (if mergedSetup.nogui.audio.spotify then [ ./nixos/optional/pkgs/misc/spotify ] else [ ])
            ++ (if mergedSetup.nogui.audio.enable then [ ./nixos/optional/drivers/audio ] else [ ])
            #   NETWORK
            ++ (
              if mergedSetup.nogui.network.vpn.server then [ ./nixos/optional/networking/vpn/server.nix ] else [ ]
            )
            ++ (
              if mergedSetup.nogui.network.vpn.client then
                [
                  (import ./nixos/optional/networking/vpn/client.nix {
                    inherit pkgs;
                    is_external = mergedSetup.nogui.network.vpn.is_external;
                  })
                ]
              else
                [ ]
            )
            ++ (
              if mergedSetup.nogui.network.wireshark then [ ./nixos/optional/pkgs/network/wireshark ] else [ ]
            )
            ++ (if mergedSetup.nogui.network.suricata then [ ./nixos/optional/pkgs/network/suricata ] else [ ])
            ++ (
              if mergedSetup.nogui.network.wifi.emergency then
                [ ./nixos/optional/networking/wifi/emergency.nix ]
              else
                [ ]
            )
            ++ (if mergedSetup.nogui.network.bluetooth then [ ./nixos/optional/drivers/bluetooth ] else [ ])
            ++ (if mergedSetup.nogui.network.can.enable then [ ./nixos/optional/network/can ] else [ ])
            ++ (if mergedSetup.nogui.network.can.peak then [ ./nixos/optional/network/can/peak.nix ] else [ ])
            #   SECURITY
            ++ (if mergedSetup.nogui.security.nikto then [ ./nixos/optional/pkgs/security/nikto ] else [ ])
            ++ (if mergedSetup.nogui.security.lynis then [ ./nixos/optional/pkgs/security/lynis ] else [ ])
            ++ (if mergedSetup.nogui.security.blocky then [ ./nixos/optional/pkgs/security/blocky ] else [ ])
            ++ (if mergedSetup.nogui.security.clamav then [ ./nixos/optional/pkgs/security/clamav ] else [ ])
            #   DRIVER
            ++ (if mergedSetup.nogui.driver.print then [ ./nixos/optional/drivers/print ] else [ ])
            #   MISC
            ++ (
              if mergedSetup.nogui.misc.xbox_controller then
                [ ./nixos/optional/pkgs/misc/xbox_controller ]
              else
                [ ]
            )
            # CONTROLLER
            ++ (if mergedSetup.controller.rpi5 then [ ./nixos/optional/controller/rpi5 ] else [ ]);
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
