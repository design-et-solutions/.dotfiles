{ pkgs, ... }:
{
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    docker-compose # Docker CLI plugin to define and run multi-container applications with Docker.
  ];
}
