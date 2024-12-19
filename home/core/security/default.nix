{ ... }:
{
  home.file = {
    ".scripts/systemd-security-check.sh" = {
      source = builtins.toString ../../../scripts/systemd-security-check.sh;
      force = true;
      executable = true;
    };
  };

  systemd.user.services.security-check-monitor = {
    description = "Monitor systemd-security-check logs and send notifications";
    serviceConfig = {
      ExecStart = "${config.home.homeDirectory}/.scripts/systemd-security-check.sh";
      Restart = "always";
    };
    wantedBy = [ "default.target" ];
  };
}
