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
A NixOS virtual machine is created with the `nix-build` command:
```shell
$ nix-build '<nixpkgs/nixos>' -A vm -I nixpkgs=channel:nixos-23.11 -I nixos-config=./configuration.nix
```
This command builds the attribute `vm` from the `nixos-23.11` release of NixOS, using the NixOS configuration as specified in the relative path.
+ The positional argument to nix-build is a path to the derivation to be built.\
  That path can be obtained from a Nix expression that evaluates to a derivation.\
  The virtual machine build helper is defined in NixOS, which is part of the nixpkgs repository.\
  Therefore we use the lookup path `<nixpkgs/nixos>`.
+ The `-A` option specifies the attribute to pick from the provided Nix expression `<nixpkgs/nixos>`.\
  To build the virtual machine, we choose the `vm` attribute as defined in `nixos/default.nix`.
+ The `-I` option prepends entries to the search path.\
  Here we set `nixpkgs` to refer to a specific version of Nixpkgs and set `nix-config` to the `configuration.nix` file in the current directory.

> [!NOTE]
> To use the current version of nixpkgs to build the virtual machine:
> ```shell
> $ nixos-rebuild build-vm -I nixos-config=./configuration.nix
> ```

### Running the virtual machine
The previous command created a link with the name result in the working directory.\
It links to the directory that contains the virtual machine.

Run the virtual machine:
```shell
$ QEMU_KERNEL_PARAMS=console=ttyS0 ./result/bin/run-nixos-vm -nographic; reset
```
This command will run QEMU in the current terminal due to `-nographic`.\
`console=ttyS0` will also show the boot process, which ends at the console login screen.\
Log in as alice with the password test.\
Check that the programs are indeed available as specified:
```shell
$ cowsay hello | lolcat
```
Exit the virtual machine by shutting it down:
```shell
$ sudo poweroff
```

> [!NOTE]
> If you forgot to add the user to wheel or didn’t set a password, stop the virtual machine from a different terminal:
> ```shell
> $ sudo pkill qemu
> ```

Running the virtual machine will create a `nixos.qcow2` file in the current directory.\
This disk image file contains the dynamic state of the virtual machine.\
It can interfere with debugging as it keeps the state of previous runs, for example the user password.\
Delete this file when you change the configuration:
```shell
$ rm nixos.qcow2
```

### Running GNOME on a graphical VM
To create a virtual machine with a graphical user interface, add the following lines to the configuration:
```nix
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
```
These three lines activate X11, the GDM display manager (to be able to login) and Gnome as desktop manager.

On NixOS, use installation-cd-graphical-gnome.nix to generate the configuration file:
```shell
$ nix-shell -I nixpkgs=channel:nixos-23.11 -p "$(cat <<EOF
  let
    pkgs = import <nixpkgs> { config = {}; overlays = []; };
    iso-config = pkgs.path + /nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix;
    nixos = pkgs.nixos iso-config;
  in nixos.config.system.build.nixos-generate-config
EOF
)"
```
```shell
$ nixos-generate-config --dir ./
```
The complete `configuration.nix` file looks like this:
```shell
{ config, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  users.users.alice = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "test";
  };

  system.stateVersion = "23.11";
}
```
To get graphical output, run the virtual machine without special options:
```shell
$ nix-build '<nixpkgs/nixos>' -A vm -I nixpkgs=channel:nixos-23.11 -I nixos-config=./configuration.nix
$ ./result/bin/run-nixos-vm
```

> [!TIP]
> See [X Window System](https://nixos.org/manual/nixos/stable/#sec-x11).

### Running Sway as Wayland compositor on a VM
To change to a Wayland compositor, disable `services.xserver.desktopManager.gnome` and enable `programs.sway`:
```nix
-  services.xserver.desktopManager.gnome.enable = true;
+  programs.sway.enable = true;
```
Running Wayland compositors in a virtual machine might lead to complications with the display drivers used by QEMU.\
You need to choose from the available drivers one that is compatible with Sway.

> [!NOTE]
> See [QEMU User Documentation](https://www.qemu.org/docs/master/system/qemu-manpage.html).

See QEMU User Documentation for options.\
One possibility is the `virtio-vga` driver:
```shell
$ ./result/bin/run-nixos-vm -device virtio-vga
```
Arguments to QEMU can also be added to the configuration file:
```nix
{ config, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  programs.sway.enable = true;

  imports = [ <nixpkgs/nixos/modules/virtualisation/qemu-vm.nix> ];
  virtualisation.qemu.options = [
    "-device virtio-vga"
  ];

  users.users.alice = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "test";
  };

  system.stateVersion = "23.11";
}
```

> [!TIP]
> See [Wayland](https://nixos.org/manual/nixos/stable/#sec-wayland).
