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

  environment.etc."audit/auditd.conf".source = "${pkgs.audit.out}/etc/audit/auditd.conf";
  environment.etc."audit/audit.rules".source = builtins.toString ./audit.rules;

  systemd.services.auditd.serviceConfig = {
    ProtectSystem = "full";
    ProtectHome = true;
    PrivateTmp = true;
    NoNewPrivileges = true;
  };
}
