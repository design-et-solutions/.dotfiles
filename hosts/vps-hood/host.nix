{ mkNixosConfiguration, ... }:

mkNixosConfiguration {
  name = "vps-hood";
  system = "x86_64-linux";
  host = ./.;
  users = [ "me" ];
  setup = {
    networking.internet = {
      ssh.root.authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMc6jbhoDuKt0YOIF9prT4reT9WG6sP2sEFVj59loQwq me@desktop-hood"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAq7LsVEV+jw4yPpLyDc4XIS2yVmSJt0J24pS4BQYtGD me@laptop-work"
      ];
      analyzer.enable = true;
    };
    security = {
      blocker.enable = true;
      analyzer.enable = true;
    };
  };
}
