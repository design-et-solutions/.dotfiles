# NixOS
Learn how to configure, install, and deploy NixOS.

## NixOS virtual machines
One of the most important features of NixOS is the ability to configure the entire system declaratively, including packages to be installed, services to be run, as well as other settings and options.

NixOS configurations can be used to test and use NixOS using a virtual machine, independent of an installation on a “bare metal” computer.

> [!WARNING]
> A NixOS configuration is a Nix language function following the NixOS module convention.\
> For a thorough treatment of the module system, check the Module system deep dive tutorial.

### Starting from a default NixOS configuration
In this tutorial you will use a default configuration that is shipped with NixOS.

> [!TIP]
> On NixOS, use the `nixos-generate-config` command to create a configuration file that contains some useful defaults and configuration suggestions.\
> Beware that the result of this command depends on your current NixOS configuration.
> NixOS minimal ISO image:
> ```shell
> $ nix-shell -I nixpkgs=channel:nixos-23.11 -p "$(cat <<EOF
>   let
>     pkgs = import <nixpkgs> { config = {}; overlays = []; };
>     iso-config = pkgs.path + /nixos/modules/installer/cd-dvd/installation-cd-minimal.nix;
>     nixos = pkgs.nixos iso-config;
>   in nixos.config.system.build.nixos-generate-config
> EOF
> )"
> ```
> It does the following:
> + Provide Nixpkgs from a channel
> + Take the configuration file for the minimal ISO image from the obtained version of the Nixpkgs repository
> + Evaluate that NixOS configuration with pkgs.nixos
> + Return the derivation which produces the `nixos-generate-config` executable from the evaluated configuration

> [!NOTE]
> By default, the generated configuration file is written to `/etc/nixos/configuration.nix`.
> To avoid overwriting this file , create a NixOS configuration in your working directory:
> ```shell
> $ nixos-generate-config --dir ./
> ```
> In the working directory you will then find two files:
> + `hardware-configuration.nix` is specific to the hardware `nix-generate-config` is being run on.\
>   Has no effect inside a virtual machine.
> + `configuration.nix` contains various suggestions and comments for the initial setup of a desktop computer.

The default NixOS configuration without comments is:
```nix
{ config, pkgs, ... }:
{
  imports =  [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "23.11";
}
```
To be able to log in, add the following lines to the returned attribute set:
```nix
  users.users.alice = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
```
We add two lightweight programs as an example:
```nix
  environment.systemPackages = with pkgs; [
    cowsay
    lolcat
  ];
```
Additionally, you need to specify a password for this user. For the purpose of demonstration only, you specify an insecure, plain text password by adding the `initialPassword` option to the user configuration:
```nix
    initialPassword = "test";
```

> [!WARNING]
> Do not use plain text passwords outside of this example unless you know what you are doing.\
> See `initialHashedPassword` or `ssh.authorizedKeys` for more secure alternatives.

### Sample configuration
```nix
{ config, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.alice = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    initialPassword = "test";
  };

  environment.systemPackages = with pkgs; [
    cowsay
    lolcat
  ];

  system.stateVersion = "23.11";
}
```
### Creating a QEMU based virtual machine from a NixOS configuration
