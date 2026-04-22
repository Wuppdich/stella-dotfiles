{ config, lib, ... }:
with lib;
let
  cfg = config.networking.contabo;
in
{
  options.networking.contabo = {
    enable = mkEnableOption "contabo networking";
    mac = mkOption {
      # TODO: match regex: https://wiki.nixos.org/wiki/NixOS_modules#Examples
      type = types.str;
    };
    addresses = mkOption {
      # TODO: match regex: https://wiki.nixos.org/wiki/NixOS_modules#Examples
      type = types.listOf types.str;
    };
    # TODO: define IPv4 gateway option, with generated as default
    # TODO: define routes option, with generated routes as default
    # TODO: define dns with contabo DNS as default.
  };

  config = mkIf cfg.enable {
    networking.useDHCP = false;
    systemd.network = {
      enable = true;
      networks."10-contabo-network" =
        let
          # Gateway assumed by setting the last byte of the ip to 1
          mkGateway = address: (builtins.elemAt (builtins.split "[[:digit:]]{1,3}$" address) 0) + "1";
          # values from `netplan get` and /run/systemd/network/*.{network|link} on the original server
          netplan = {
            dns = [
              "213.136.95.10"
              "213.136.95.11"
              "2a02:c207::1:53"
            ];
            routes = [
              # the "Destinatin=default" part can be omitted
              {
                # FIXME: IPv4 address assumed to be in first position
                Gateway = mkGateway (builtins.elemAt cfg.addresses 0);
                GatewayOnLink = true;
              }
              {
                Gateway = "fe80::1";
                GatewayOnLink = true;
              }
            ];
          };
        in
        {
          enable = true;
          matchConfig.PermanentMACAddress = cfg.mac;
          address = cfg.addresses;
          dns = netplan.dns;
          routes = netplan.routes;
          linkConfig.RequiredForOnline = "routable";
        };
    };
  };
}
