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

## Integration testing with NixOS virtual machines
Nixpkgs provides a test environment to automate integration testing for distributed systems.\
It allows defining tests based on a set of declarative NixOS configurations and using a Python shell to interact with them through QEMU as the backend.\
Those tests are widely used to ensure that NixOS works as intended, so in general they are called NixOS Tests.\
They can be written and launched outside of NixOS, on any Linux machine.

Integration tests are reproducible due to the design properties of Nix, making them a valuable part of a continuous integration (CI) pipeline.

### The `testers.runNixOSTest` function
NixOS VM tests are defined using the `testers.runNixOSTest` function.\
The pattern for NixOS VM tests looks like this:
```nix
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.testers.runNixOSTest {
  name = "test-name";
  nodes = {
    machine1 = { config, pkgs, ... }: {
      # ...
    };
    machine2 = { config, pkgs, ... }: {
      # ...
    };
  };
  testScript = { nodes, ... }: ''
    # ...
  '';
}
```
The function `testers.runNixOSTest` takes a module to specify the test options.\
Because this module only sets configuration values, one can use the abbreviated module notation.

The following configuration values must be set:
+ `name` defines the name of the test.
+ `nodes` contains a set of named configurations, because a test script can involve more than one virtual machine.\
  Each virtual machine is created from a NixOS configuration.
+ `testScript` defines the Python test script, either as literal string or as a function that takes a nodes attribute.\
  This Python test script can access the virtual machines via the names used for the nodes.\
  It has super user rights in the virtual machines.\
  In the Python script each virtual machine is accessible via the machine object.\
  NixOS provides various methods to run tests on these configurations.

The test framework automatically starts the virtual machines and runs the Python script.

### Minimal example
As a minimal test on the default configuration, we will check if the user `root` and `alice` can run `firefox`.\
We will build the example up from scratch.

The complete minimal-test.nix file content looks like the following:
```nix
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.testers.runNixOSTest {
  name = "minimal-test";

  nodes.machine = { config, pkgs, ... }: {

    users.users.alice = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      packages = with pkgs; [
        firefox
        tree
      ];
    };

    system.stateVersion = "23.11";
  };

  testScript = ''
    machine.wait_for_unit("default.target")
    machine.succeed("su -- alice -c 'which firefox'")
    machine.fail("su -- root -c 'which firefox'")
  '';
}
```
+ Use a pinned version of Nixpkgs, and explicitly set configuration options and overlays to avoid them being inadvertently overridden by global configuration.
+ Label the test with a descriptive name.
+ Because this example only uses one virtual machine, the node we specify is simply called machine.\
  This name is arbitrary and can be chosen freely.\
  As configuration you use the relevant parts of the default configuration, that we used in a previous tutorial.
+ And the test script.
  This Python script refers to `machine` which is the name chosen for the virtual machine configuration used in the `nodes` attribute set.
  The script waits until systemd reaches `default.target`.\
  It uses the `su` command to switch between users and the `which` command to check if the user has access to `firefox`.\
  It expects that the command `which firefox` to succeed for user `alice` and to fail for `root`.\
  This script will be the value of the `testScript` attribute.

### Running tests
To set up all machines and run the test script:
```shell
$ nix-build minimal-test.nix
...
test script finished in 10.96s
cleaning up
killing machine (pid 10)
(0.00 seconds)
/nix/store/bx7z3imvxxpwkkza10vb23czhw7873w2-vm-test-run-minimal-test
```

### Interactive Python shell in the virtual machine
When developing tests or when something breaks, it’s useful to interactively tinker with the test or access a terminal for a machine.\
To start an interactive Python session with the testing framework:
```shell
$ $(nix-build -A driverInteractive minimal-test.nix)/bin/nixos-test-driver
```
Here you can run any of the testing operations.\
Execute the `testScript` attribute from `minimal-test.nix` with the `test_script()` function.

If a virtual machine is not yet started, the test environment takes care of it on the first call of a method on a `machine` object.\
But you can also manually trigger the start of the virtual machine for a specific node with:
```shell
>>> machine.start()
```
Or for all nodes with:
```shell
>>> start_all()
```
You can enter a interactive shell on the virtual machine using:
```shell
>>> machine.shell_interact()
```
Then, run shell commands like:
```shell
uname -a
```
```shell
Linux server 5.10.37 #1-NixOS SMP Fri May 14 07:50:46 UTC 2021 x86_64 GNU/Linux
```

> [!NOTE]
> Because test results are kept in the Nix store, a successful test is cached.\
> This means that Nix will not run the test a second time as long as the test setup (node configuration and test script) stays semantically the same.\
> Therefore, to run a test again, one needs to remove the result.\
> Remove the symbolic link and only then remove the cached result:
> ```shell
> rm ./result
> nix-store --delete /nix/store/4klj06bsilkqkn6h2sia8dcsi72wbcfl-vm-test-run-unnamed
> ```

### Tests with multiple virtual machines
Tests can involve multiple virtual machines, for example to test client-server-communication.

The following example setup includes:
+ A virtual machine named `server` running nginx with default configuration.
+ A virtual machine named `client` that has `curl` available to make an HTTP request.
+ A `testScript` orchestrating testing logic between `client` and `server`.
  
The complete `client-server-test.nix` file content looks like the following:
```nix
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.testers.runNixOSTest {
  name = "client-server-test";

  nodes.server = { pkgs, ... }: {
    networking = {
      firewall = {
        allowedTCPPorts = [ 80 ];
      };
    };
    services.nginx = {
      enable = true;
      virtualHosts."server" = {};
    };
  };

  nodes.client = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      curl
    ];
  };

  testScript = ''
    server.wait_for_unit("default.target")
    client.wait_for_unit("default.target")
    client.succeed("curl http://server/ | grep -o \"Welcome to nginx!\"")
  '';
}
```
The test script performs the following steps:
+ Start the server and wait for it to be ready.
+ Start the client and wait for it to be ready.
+ Run `curl` on the client and use `grep` to check the expected return string.\
  The test passes or fails based on the return value.

Run the test:
```shell
$ nix-build client-server-test.nix
```

### Additional information regarding NixOS tests
+ Running integration tests on CI requires hardware acceleration, which many CIs do not support.

> [!WARNING]
> To run integration tests in GitHub Actions see (how to disable hardware acceleration)[https://github.com/cachix/install-nix-action#how-do-i-run-nixos-tests].

+ NixOS comes with a large set of tests that can serve as educational examples.
+ A good inspiration is Matrix bridging with an IRC.

## Building a bootable ISO image
