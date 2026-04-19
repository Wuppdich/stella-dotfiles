{ ... }:
{
  networking.useDHCP = false;
  systemd.network = {
    enable = true;
    networks."10-nix-network" =
      let
        # values from `netplan get` and /run/systemd/network/*.{network|link} on the original server
        netplan = {
          mac = "00:00:00:00:00:00";
          addresses = [
            "123.123.123.123/23"
            "1234:1234:1234:1234::1/64"
          ];
          dns = [
            "213.136.95.10"
            "213.136.95.11"
            "2a02:c207::1:53"
          ];
          routes = [
            {
              # the "Destinatin=default" part can be omitted
              Gateway = "123.123.123.1";
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
        matchConfig.PermanentMACAddress = netplan.mac;
        address = netplan.addresses;
        dns = netplan.dns;
        routes = netplan.routes;
        linkConfig.RequiredForOnline = "routable";
      };
  };
}
