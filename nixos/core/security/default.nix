{ pkgs, ... }: {
  imports = [
    ./systemd.nix
    ./audit.nix
  ];


  environment.systemPackages = with pkgs; [ vulnix ];
  # security.auditd.enable

  # systemd.services.auditd = {
  #   description = "Linux Audit daemon";
  #   wantedBy = [ "sysinit.target" ];
  #   after = [
  #     "local-fs.target"
  #     "systemd-tmpfiles-setup.service"
  #   ];
  #   before = [
  #     "sysinit.target"
  #     "shutdown.target"
  #   ];
  #   conflicts = [ "shutdown.target" ];
  #
  #   unitConfig = {
  #     ConditionVirtualization = "!container";
  #     ConditionSecurity = [ "audit" ];
  #     DefaultDependencies = false;
  #   };
  #
  #   path = [ pkgs.audit ];
  #
  #   serviceConfig = {
  #     ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /var/log/audit";
  #     ExecStart = "${pkgs.audit}/bin/auditd -l -n -s nochange";
  #   };
  # };
  #
  # environment.systemPackages = with pkgs; [
  #   # acct
  #
  #   audit
  #   # rkhunter
  # ];

  #
  # systemd.services.enableProcessAccounting = {
  #   description = "Enable process accounting";
  #   wantedBy = [ "multi-user.target" ];
  #   script = ''
  #     export PATH=${pkgs.acct}/bin:$PATH
  #
  #     mkdir -p /var/log/account
  #     touch /var/log/account/pacct
  #     chmod 600 /var/log/account/pacct
  #     accton /var/log/account/pacct
  #   '';
  # };
}

