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

        coulon = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./machines/coulon
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            musnix.nixosModules.musnix
          ];
          specialArgs = { inherit inputs; };
        };

        foxglove = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./machines/foxglove
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
          ];
        };

      };
    };
}
