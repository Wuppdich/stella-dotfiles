{ ... }: {
  virtualisation.quadlet.containers = {
    nginx = {
      containerConfig = {
        image = "docker.io/library/nginx:latest";
        publishPorts = [ "80:80" ];
      };
    };
  };
}
