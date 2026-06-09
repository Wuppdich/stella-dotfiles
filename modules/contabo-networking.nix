{ config, lib, ... }:
let
  inherit (builtins) elemAt split;
  inherit (lib) mkEnableOption mkOption mkIf;
  inherit (lib.types) str listOf strMatching;

  cfg = config.networking.contabo;

  # Gateway assumed by setting the last byte of the ip to 1
  mkGateway = address: (elemAt (split "[[:digit:]]{1,3}\/[[:digit:]]{1,2}$" address) 0) + "1";
in
{
  options.networking.contabo = {
    enable = mkEnableOption "contabo networking";

    mac = mkOption {
      type = strMatching "^([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}$";
      example = "12:23:45:67:89:AB";
    };

    addrIPv4 = mkOption {
      # half-arsed implementation. posix regex is really annoying >.<
      type = strMatching "^([[:digit:]]{1,3}.?){4}\/[[:digit:]]{1,2}$";
      example = "192.178.1.64/24";
    };

    addrIPv6 = mkOption {
      # half-arsed implementation. posix regex is really annoying >.<
      type = strMatching "^([[:xdigit:]]{0,4}:?|::){2,8}\/[[:digit:]]{1,2}$";
      example = "12ab:34cd:56ef:78ff::1/64";
    };

    address = mkOption {
      type = listOf str;
      default = [
        cfg.addrIPv4
        cfg.addrIPv6
      ];
    };

    gatewayIPv4 = mkOption {
      # half-arsed implementation. posix regex is really annoying >.<
      type = strMatching "^([[:digit:]]{1,3}.?){4}$";
      default = mkGateway cfg.addrIPv4;
      example = "192.178.1.1";
    };

    gatewayIPv6 = mkOption {
      # half-arsed implementation. posix regex is really annoying >.<
      type = strMatching "^([[:xdigit:]]{0,4}:?|::){2,8}$";
      default = "fe80::1";
      example = "12ab:34cd:56ef:78ff::1";
    };

    routes = mkOption {
      default = [
        # the "Destinatin=default" part can be omitted
        {
          Gateway = cfg.gatewayIPv4;
          GatewayOnLink = true;
        }
        {
          Gateway = cfg.gatewayIPv6;
          GatewayOnLink = true;
        }
      ];
    };

    dns = mkOption {
      type = listOf str;
      default = [
        "213.136.95.10"
        "213.136.95.11"
        "2a02:c207::1:53"
      ];
      example = [
        "8.8.8.8"
        "8.8.4.4"
        "2001:4860:4860::8888"
      ];
    };
  };

  config = mkIf cfg.enable {
    networking.useDHCP = false;
    systemd.network = {
      enable = true;
      networks."10-contabo-network" = {
        enable = true;
        matchConfig.PermanentMACAddress = cfg.mac;
        inherit (cfg) address routes dns;
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
}
