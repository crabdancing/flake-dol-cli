{
  pkgs,
  geoip-db,
}: let
  trippy = pkgs.symlinkJoin {
    name = "trippy";
    meta.mainProgram = "trip";
    paths = [pkgs.trippy];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram "$out/bin/trip" \
        --add-flags --geoip-mmdb-file --add-flags ${geoip-db}/share/db/GeoLite2-City.mmdb
    '';
  };
in
  trippy
