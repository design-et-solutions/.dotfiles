{ pkgs, ... }:
{
  home.file.".cargo/config.toml".source = pkgs.writeText "cargo-config" ''
    [target.x86_64-unknown-linux-gnu]
    linker = "clang"
    rustflags = ["-C", "link-arg=-fuse-ld=${pkgs.mold}/bin/mold"]
  '';

  home.packages = with pkgs; [
    diesel-cli
  ];
}
