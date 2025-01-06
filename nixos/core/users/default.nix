{
  systemd.user.services = {
    # Apply settings for all user services (user@*)
    "*".serviceConfig = {
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectHome = true;
      ProtectSystem = "full";
    };
  };
}
