{ values, ... }: {
  services = {
    caddy = {
      enable = true;
      openFirewall = true;
      email = values.eMail;
      globalConfig = "local_certs";
      virtualHosts = {
        "elster" = {
          hostName = "elster";
          extraConfig = "reverse_proxy localhost:8080";
        };
      };
    };
    qbittorrent = {
      enable = true;
      serverConfig.Preferences.WebUI.LocalHostAuth = false;
    };
  };
}
