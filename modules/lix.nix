{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.garden.lix;
in
{
  options.garden.lix.enable = mkEnableOption "lix";
  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        inherit (prev.lixPackageSets.stable)
          nixpkgs-review
          nix-eval-jobs
          nix-fast-build
          colmena
          ;
      })
    ];
    nix.package = pkgs.lixPackageSets.stable.lix;
  };
}
