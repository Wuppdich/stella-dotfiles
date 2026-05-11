{
  inputs = {
    # use channel tarball instead of github. thanks isabel :)
    # https://github.com/isabelroses/dotfiles/blob/main/flake.nix#L9
    nixpkgs.url = "https://channels.nixos.org/nixos-25.11/nixexprs.tar.xz";
    nixpkgs-unstable.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    musnix.url = "github:musnix/musnix";
    musnix.inputs.nixpkgs.follows = "nixpkgs";
    secrets = {
      url = "git+ssh://git@git.gay/stellawupp/stella-dotfiles-secrets.git?ref=main&shallow=1";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      disko,
      sops-nix,
      home-manager,
      musnix,
      ...
    }@inputs:
    {
      # Use this for all other targets
      # nixos-anywhere --flake .#generic --generate-hardware-config nixos-generate-config ./hardware-configuration.nix <hostname>
      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          modules = [
          ];
        };

        # nix run github:nix-community/nixos-anywhere -- \
        #     --generate-hardware-config nixos-generate-config ./hardware-configuration.nix \
        #     --flake ./#egg \
        #     --target-host root@123.123.123.123
        egg = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./machines/egg
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
          ];
          specialArgs = { inherit inputs; };
        };

        coulon = nixpkgs.lib.nixosSystem {
          modules = [
            ./machines/coulon
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            musnix.nixosModules.musnix
          ];
          specialArgs = { inherit inputs; };
        };

        pyrit = nixpkgs.lib.nixosSystem {
          modules = [
            ./machines/pyrit
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            musnix.nixosModules.musnix
          ];
          specialArgs = { inherit inputs; };
        };

        rabe = nixpkgs.lib.nixosSystem {
          modules = [
            ./machines/rabe
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
          ];
          specialArgs = { inherit inputs; };
        };

      };
    };
}
