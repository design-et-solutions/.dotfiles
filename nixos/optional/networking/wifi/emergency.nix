{ ... }:
{
  networking.wireless = {
    networks.Emergency = {
      psk = "%saveme%";
    };
  };

  systemd.services.emergency.serviceConfig = {
    NoNewPrivileges = true;

    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectHostname = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    ProtectProc = "invisible";
    ProtectClock = true;

    PrivateTmp = true;
    PrivateMounts = true;
    PrivateDevices = true;

    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;

    MemoryDenyWriteExecute = true;

    LockPersonality = true;

    SystemCallFilter = [
      "~@debug"
      "~@raw-io"
      "~@resources"
      "~@privileged"
      "~@reboot"
      "~@clock" # Deny clock operations
      "~@module" # Deny kernel operations
      "~@mount" # Deny mount operations
      "~@swap" # Deny swap operations
      "~@obsolete" # Deny system calls outdated, deprecated, or rarely used in modern Linux systems
      "~@cpu-emulation" # Deny system calls that are related to CPU state manipulation or virtualization
    ];
    SystemCallArchitectures = "native";

    CapabilityBoundingSet = [
      "~CAP_SYS_ADMIN"
    ];
  };
}
