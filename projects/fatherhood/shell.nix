{ pkgs ? import <nixpkgs> {} }: pkgs.mkShell {
  buildInputs = [
    pkgs.pkg-config
    pkgs.libpulseaudio
    pkgs.openssl
    pkgs.ffmpeg
    pkgs.clang
    pkgs.llvmPackages.libclang
  ];

  shellHook = ''
    export LD_LIBRARY_PATH=${pkgs.libclang}/lib:${pkgs.libpulseaudio}/lib:$LD_LIBRARY_PATH
    export PKG_CONFIG_PATH=${pkgs.libclang}/lib/pkgconfig:${pkgs.libpulseaudio}/lib/pkgconfig:$PKG_CONFIG_PATH
    export LIBCLANG_PATH=${pkgs.llvmPackages.libclang.lib}/lib
    export BINDGEN_EXTRA_CLANG_ARGS="-I${pkgs.llvmPackages.libclang.lib}/lib/clang/${pkgs.llvmPackages.libclang.version}/include"
  '';
}
