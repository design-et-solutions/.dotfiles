{ pkgs, allowedPorts, ... }:
{
  # https://search.nixos.org/options?channel=24.11&query=networking
  networking = {
    enableIPv6 = true;
    networkmanager = {
      enable = true;
    };
    # https://search.nixos.org/options?query=networking.firewall
    firewall = {
      enable = true;
      logRefusedConnections = true;
      allowedTCPPorts = [
        80
        443
        8080
        3000
        9999
        8554
      ];
      allowedUDPPorts = [ 53 ];
    };
  };

  # Managing network connections on Linux systems.
  systemd.services.NetworkManager.serviceConfig = {
    NoNewPrivileges = true;
    ProtectHome = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectClock = true;
    ProtectHostname = true;
    ProtectProc = "invisible";
    PrivateTmp = true;
    RestrictRealtime = true;
    RestrictAddressFamilies = [
      "AF_UNIX"
      "AF_NETLINK"
      "AF_INET"
      "AF_INET6"
      "AF_PACKET"
    ];
    RestrictNamespaces = true;
    RestrictSUIDSGID = true;
    MemoryDenyWriteExecute = true;
    SystemCallFilter = [
      "~@mount"
      "~@module"
      "~@swap"
      "~@obsolete"
      "~@cpu-emulation"
      "ptrace"
    ];
    SystemCallArchitectures = "native";
    LockPersonality = true;
  };

  # Runs custom scripts or actions when specific network-related events occur.
  systemd.services.NetworkManager-dispatcher.serviceConfig = {
    NoNewPrivileges = true;
    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectClock = true;
    ProtectHostname = true;
    ProtectProc = "invisible";
    PrivateTmp = true;
    PrivateMounts = true;
    RestrictRealtime = true;
    RestrictAddressFamilies = [
      "AF_UNIX"
      "AF_NETLINK"
      "AF_INET"
      "AF_INET6"
      "AF_PACKET"
    ];
    RestrictNamespaces = true;
    RestrictSUIDSGID = true;
    MemoryDenyWriteExecute = true;
    SystemCallFilter = [
      "~@mount"
      "~@module"
      "~@swap"
      "~@obsolete"
      "~@cpu-emulation"
      "ptrace"
    ];
    SystemCallArchitectures = "native";
    LockPersonality = true;
    CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_RAW";
  };

  # Managing wireless network connections
  systemd.services.wpa_supplicant.serviceConfig = {
    NoNewPrivileges = true;
    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectClock = true;
    ProtectHostname = true;
    ProtectProc = "invisible";
    PrivateTmp = true;
    PrivateMounts = true;
    RestrictRealtime = true;
    RestrictAddressFamilies = [
      "AF_UNIX"
      "AF_NETLINK"
      "AF_INET"
      "AF_INET6"
      "AF_PACKET"
    ];
    RestrictNamespaces = true;
    RestrictSUIDSGID = true;
    MemoryDenyWriteExecute = true;
    SystemCallFilter = [
      "~@mount"
      "~@raw-io"
      "~@privileged"
      "~@keyring"
      "~@reboot"
      "~@module"
      "~@swap"
      "~@resources"
      "~@obsolete"
      "~@cpu-emulation"
      "ptrace"
    ];
    SystemCallArchitectures = "native";
    LockPersonality = true;
    CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_RAW";
  };

  programs.mtr.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [
    networkmanager # Network configuration and management tool
    protobuf # Google's data interchange format
    nmap # Network exploration and security auditing utility
    wget # Tool for retrieving files using HTTP, HTTPS, and FTP
    websocat # Command-line client for WebSockets
    curl # Command-line tool for transferring data using various protocols
  ];
}
