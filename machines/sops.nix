{ inputs, ... }: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = "${builtins.toString inputs.secrets}/secrets.yaml";
    age = {
      # we want no generated keys
      sshKeyPaths = [ ];
      generateKey = false;
      keyFile = "/var/lib/sops-nix/key.txt";
    };
  };
}
