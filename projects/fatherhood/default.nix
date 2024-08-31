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
    ];
    sessionVariables = {
      PKG_CONFIG_PATH = "${ffmpeg.dev}/lib/pkgconfig:${pkgs.lib.makeLibraryPath [ffmpeg]}:$PKG_CONFIG_PATH";
      FFMPEG_PKG_CONFIG_PATH = "${ffmpeg.dev}/lib/pkgconfig";
      LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
      LD_LIBRARY_PATH = "${ffmpeg.lib}/lib:${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH";
      C_INCLUDE_PATH = "${pkgs.clang}/resource-root/include:${pkgs.glibc.dev}/include:${pkgs.gcc}/lib/gcc/${pkgs.stdenv.hostPlatform.config}/${pkgs.gcc.version}/include:${pkgs.stdenv.cc.cc.lib}/include:$C_INCLUDE_PATH";
      CPLUS_INCLUDE_PATH = "${pkgs.clang}/resource-root/include:${pkgs.glibc.dev}/include:${pkgs.gcc}/lib/gcc/${pkgs.stdenv.hostPlatform.config}/${pkgs.gcc.version}/include:${pkgs.stdenv.cc.cc.lib}/include/c++:$CPLUS_INCLUDE_PATH";
      BINDGEN_EXTRA_CLANG_ARGS = "-I${pkgs.clang}/resource-root/include -I${pkgs.glibc.dev}/include -I${pkgs.gcc}/lib/gcc/${pkgs.stdenv.hostPlatform.config}/${pkgs.gcc.version}/include";
    };
  };
}
