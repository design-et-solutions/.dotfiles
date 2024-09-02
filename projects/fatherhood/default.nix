{ pkgs, ... }:{
  home = {
    packages = with pkgs; [
      # gateway
      ffmpeg
      # cli
      openssl.dev
      # tools -> sonify
      alsaLib
    ];
    file = {
      ".local/share/fatherhood/.env".source = ./.env;
      ".local/share/fatherhood/cantrolly".source = ./cantrolly;
      ".local/share/fatherhood/gateway".source = ./gateway;
      ".local/share/fatherhood/registry".source = ./registry;
      ".local/share/fatherhood/visionary".source = ./visionary;
    };
  };
}
