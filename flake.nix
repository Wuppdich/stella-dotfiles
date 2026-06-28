{
  inputs = {
    # use channel tarball instead of github. thanks isabel :)
    # https://github.com/isabelroses/dotfiles/blob/46e52fb3b035345eddb5cce9744cf1804a0ee9ea/flake.nix#L9
    nixpkgs.url = "https://channels.nixos.org/nixos-26.05/nixexprs.tar.xz";
    nixpkgs-unstable.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets = {
      url = "git+ssh://git@git.gay/stellawupp/stella-dotfiles-secrets.git?ref=main&shallow=1";
      flake = false;
    };
    quadlet-nix = {
      url = "github:SEIAROTg/quadlet-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      ...
    }@inputs:
    {
      # Use this for all other targets
      # nixos-anywhere --flake .#generic --generate-hardware-config nixos-generate-config ./hardware-configuration.nix <hostname>
      nixosConfigurations = {
        # the default should do nothing
        default = inputs.nixpkgs.lib.nixosSystem { };

        # nix run github:nix-community/nixos-anywhere -- \
        #     --generate-hardware-config nixos-generate-config ./machines/egg/hardware-configuration.nix \
        #     --flake ./#egg \
        #     --target-host root@123.123.123.123
        egg = inputs.nixpkgs.lib.nixosSystem {
          modules = [ ./machines/egg ];

          specialArgs = { inherit inputs; };
        };

        coulon = inputs.nixpkgs.lib.nixosSystem {
          modules = [ ./machines/coulon ];

          specialArgs = { inherit inputs; };
        };

        pyrit = inputs.nixpkgs.lib.nixosSystem {
          modules = [ ./machines/pyrit ];

          specialArgs = { inherit inputs; };
        };

        rabe = inputs.nixpkgs.lib.nixosSystem {
          modules = [ ./machines/rabe ];

          specialArgs = { inherit inputs; };
        };

      };
    };
}
