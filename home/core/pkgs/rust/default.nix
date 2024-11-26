{ ... }:
{
  xdg.configFile.".cargo/config.toml".source = pkgs.writeText "cargo-config" ''
    [build]
    rustflags = ["-C", "linker=mold"]
  '';
}
