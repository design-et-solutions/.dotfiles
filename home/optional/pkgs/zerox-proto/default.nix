{ lib, stdenv, fetchzip }:
stdenv.mkDerivation rec {
  pname = "zerox-proto";
  version = "1.0";

  src = fetchzip {
    url = "https://github.com/0xType/0xProto/releases/download/2.100/0xProto_2_100.zip";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype/
  '';

  meta = with lib; {
    description = "0xProto font";
    homepage = "https://github.com/0xType/0xProto";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}