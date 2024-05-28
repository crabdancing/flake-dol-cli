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
    in {
      # Packages exposed by this flake
      packages = pkgs.callPackage pkgs/trippy.nix {
        inherit geoip-db;
      };
    });
}
