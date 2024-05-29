# TODO:
# - remove symlinkJoin from tui impl.
# - instead of exposing a package, we will expose a module.
# - module must include common (non-secret) configuration,
# - patches, fixes, and shells themselves.
{
  description = "A simple flake containing a common set of TUI tools";

  # Define flake inputs
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    flake-geoip.url = "github:crabdancing/flake-geoip";
  };

  # Define outputs
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config = {};
      };

      geoip-db =
        inputs.flake-geoip.packages.${system}.default;
      trippy = pkgs.callPackage pkgs/trippy.nix {
        inherit geoip-db;
      };
      paths =
        [
          trippy
        ]
        ++ (with pkgs; [
          du-dust
          diskonaut
        ]);
      # experimenting with this approach, but honestly, clobbering file trees this way seems kinda dumb
      # probably should just build a nix module and add the packages that way
      tui = pkgs.symlinkJoin {
        name = "tui";
        inherit paths;
      };
    in {
      packages = {
        inherit trippy tui;
        default = tui;
      };
    });
}
