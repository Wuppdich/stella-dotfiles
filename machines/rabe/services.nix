{ values, ... }: {
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
      virtualHosts."testing.stel.gay" = {
        hostName = "testing.stel.gay";
        extraConfig = "reverse_proxy 127.0.0.1:8080";
      };
    };
  };
}
