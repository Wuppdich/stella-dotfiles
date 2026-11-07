{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.garden.fail2ban;
in
{
  options.garden.fail2ban.enable = mkEnableOption "fail2ban";

  config = mkIf cfg.enable {
    services.fail2ban = {
      enable = true;
      ignoreIP = [
        "127.0.0.0/8"
        "10.0.0.0/8"
        "192.168.0.0/16"
      ];
      bantime-increment = {
        enable = true;
        overalljails = true;
        rndtime = "15m";
        multipliers = "1 4 16 64 256 1024 2048";
        maxtime = "7d";
      };
    };
  };
}
