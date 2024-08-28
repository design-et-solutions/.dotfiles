{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (python3.withPackages(ps: with ps; [
      flask
      flask-socketio
      eventlet
      colorama
      pynput
    ]))
  ];
}
