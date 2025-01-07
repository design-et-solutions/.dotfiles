{ pkgs, ... }: {
  # The Linux audit framework provides a CAPP-compliant (Controlled Access Protection Profile) \
  # auditing system that reliably collects information \
  # about any security-relevant (or non-security-relevant) event on a system. 
  # It can help you track actions performed on a system.
  security = {
    # Enables the Linux audit framework in the kernel.
    audit = {
      enable = true;
    };
    # Enables the auditd service, which is the user-space daemon for the Linux audit framework.
    auditd = {
      enable = true;
    };
  };

  environment.etc = {
    "audit/auditd.conf" = {
      source = "${pkgs.audit.out}/etc/audit/auditd.conf";
      mode = "0400";
    };
    "audit/audit.rules" = {
      source = builtins.toString ./audit.rules;
      mode = "0400";
    };
  };

  # Collecting, recording, and managing security-related audit events on the system.
  systemd.services.auditd.serviceConfig = {
    NoNewPrivileges = true;

    ProtectSystem = "full";
    ProtectHome = true;
    ProtectHostname = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true; 
    ProtectProc = "invisible";
    ProtectClock = true;

    PrivateTmp = true;
    PrivateNetwork = true;
    PrivateMounts = true;
    PrivateDevices = true;

    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RestrictAddressFamilies = [ 
      "~AF_INET6"  
      "~AF_INET"
      "~AF_PACKET"
    ];

    MemoryDenyWriteExecute = true;

    LockPersonality = true;

    SystemCallFilter = [
      "~@clock"         # Deny clock operations
      "~@module"        # Deny kernel operations
      "~@mount"         # Deny mount operations
      "~@swap"          # Deny swap operations
      "~@obsolete"      # Deny system calls outdated, deprecated, or rarely used in modern Linux systems 
      "~@cpu-emulation" # Deny system calls that are related to CPU state manipulation or virtualization 
    ];
    SystemCallArchitectures = "native";

    CapabilityBoundingSet= [
      "~CAP_MAC_*"
      "~CAP_CHOWN"
      "~CAP_FSETID"
      "~CAP_SETFCAP"
    ];
  };
}
