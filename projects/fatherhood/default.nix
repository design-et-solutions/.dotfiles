{ pkgs, ... }:
let
  ffmpeg = pkgs.ffmpeg-full.override {
    withUnfree = true;  # Include non-free codecs if needed
  };
in {
  # dependency
  environment = {
    systemPackages = with pkgs; [
      ffmpeg-full
      pkg-config
      clang
      llvmPackages.libclang
      stdenv.cc.cc.lib
      glibc.dev
      gcc
      openssl.dev
    ];
    sessionVariables = {
      PKG_CONFIG_PATH = "${ffmpeg.dev}/lib/pkgconfig:${pkgs.lib.makeLibraryPath [ffmpeg]}:$PKG_CONFIG_PATH";
      FFMPEG_PKG_CONFIG_PATH = "${ffmpeg.dev}/lib/pkgconfig";
      LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
      LD_LIBRARY_PATH = "${ffmpeg.lib}/lib:${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH";
      C_INCLUDE_PATH = "${pkgs.clang}/resource-root/include:${pkgs.glibc.dev}/include:${pkgs.gcc}/lib/gcc/${pkgs.stdenv.hostPlatform.config}/${pkgs.gcc.version}/include:${pkgs.stdenv.cc.cc.lib}/include:$C_INCLUDE_PATH";
      CPLUS_INCLUDE_PATH = "${pkgs.clang}/resource-root/include:${pkgs.glibc.dev}/include:${pkgs.gcc}/lib/gcc/${pkgs.stdenv.hostPlatform.config}/${pkgs.gcc.version}/include:${pkgs.stdenv.cc.cc.lib}/include/c++:$CPLUS_INCLUDE_PATH";
      BINDGEN_EXTRA_CLANG_ARGS = "-I${pkgs.clang}/resource-root/include -I${pkgs.glibc.dev}/include -I${pkgs.gcc}/lib/gcc/${pkgs.stdenv.hostPlatform.config}/${pkgs.gcc.version}/include";
      OPENSSL_DIR = "${pkgs.openssl.dev}";
      OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
      OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
    };
    etc = {
      "fatherhood/.env".source = ./.env;
      "fatherhood/cantrolly".source = ./cantrolly;
      "fatherhood/gateway".source = ./gateway;
      "fatherhood/registry".source = ./registry;
      "fatherhood/visionary".source = ./visionary;
    };
  };

  systemd.services = {
    fatherhood-gateway = {
      description = "Service Fatherhood Gateway";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "fatherhood-registry.service" ];
      requires = [ "fatherhood-registry.service" ];
      serviceConfig = {
        ExecStart = "/etc/fatherhood/gateway";
        Restart = "always";
        RestartSec = "30s";
      };
    };
    fatherhood-registry = {
      description = "Service Fatherhood Registry";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "/etc/fatherhood/registry";
        Restart = "always";
        RestartSec = "30s";
      };
    };
    fatherhood-cantrolly = {
      description = "Service Fatherhood Cantrolly";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "fatherhood-registry.service" ];
      requires = [ "fatherhood-registry.service" ];
      serviceConfig = {
        ExecStart = "/etc/fatherhood/cantrolly";
        Restart = "always";
        RestartSec = "30s";
      };
    };
    fatherhood-visionary = {
      description = "Service Fatherhood Visionary";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "fatherhood-registry.service" ];
      requires = [ "fatherhood-registry.service" ];
      serviceConfig = {
        ExecStart = "/etc/fatherhood/visionary";
        Restart = "always";
        RestartSec = "30s";
      };
    };
  };
}
