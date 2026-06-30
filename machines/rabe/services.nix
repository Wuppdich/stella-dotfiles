{ config, values, ... }: {

  sops = {
    secrets = {
      "rabe/rathole/noise-private" = { };
      "rabe/rathole/jellyfin-token" = { };
    };
    templates."rathole-secrets.toml".content = ''
      [server.transport.noise]
      local_private_key = "${config.sops.placeholder."rabe/rathole/noise-private"}"

      [server.services.jellyfin]
      token = "${config.sops.placeholder."rabe/rathole/jellyfin-token"}"
    '';
  };

  services = {
    openssh = {
      enable = true;
    };

    caddy = {
      enable = true;
      # acmeCA = "https://acme-staging-v02.api.letsencrypt.org/directory"; # use this for staging
      acmeCA = null; # use this for prod
      openFirewall = true;
      email = values.eMail;
      virtualHosts = {
        "jellyfin.stel.gay" = {
          hostName = "jellyfin.stel.gay";
          extraConfig = "reverse_proxy 127.0.0.1:8096";
        };
        "testing.stel.gay" = {
          hostName = "testing.stel.gay";
          extraConfig = "reverse_proxy 127.0.0.1:8080";
        };
      };
    };

    rathole = {
      enable = true;
      role = "server";
      settings = {
        server = {
          bind_addr = "0.0.0.0:2333";
          transport.type = "noise";
          services.jellyfin = {
            type = "tcp";
            bind_addr = "127.0.0.1:8096";
          };
        };
      };
      credentialsFile = config.sops.templates."rathole-secrets.toml".path;
    };
  };

  networking.firewall.allowedTCPPorts = [ 2333 ];
}
