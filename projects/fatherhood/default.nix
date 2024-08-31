{ pkgs, ... }:{
  # dependency
  environment = {
    systemPackages = with pkgs; [
      ffmpeg
      pkg-config
      clang
      llvmPackages.libclang
    ];
    variables = {
      LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
    };
  };
}
