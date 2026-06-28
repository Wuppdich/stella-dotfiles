{ ... }: {
  virtualisation.quadlet.containers = {
    nginx = {
      containerConfig = {
        image = "docker.io/library/nginx:latest";
        publishPorts = [ "127.0.0.1:8080:80" ];
      };
    };
  };
}
