{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  system = {
    autoUpgrade = {
      enable = mkDefault true;
      dates = "01:00";
      fixedRandomDelay = true;
      randomizedDelaySec = "3h";
      upgrade = false;
      flake = "github:Wuppdich/stella-dotfiles";
      operation = mkDefault "boot";
      allowReboot = mkDefault false;
      rebootWindow = {
        lower = "01:00";
        upper = "05:00";
      };
      # FIXME: prevents OOM's. leave this at 1 until we have a way to monitor rebuild's RAM-usage
      flags = [ "--max-jobs 1" ];
      runGarbageCollection = true;
    };
  };
}
