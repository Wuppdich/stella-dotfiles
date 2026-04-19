{
  inputs = {
    # use brand (eg. "nixos-25.11") not tags (eg "25.11") or you won't get backports
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOs/nixpkgs/nixos-unstable";
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
            disko.nixosModules.disko
            ./configuration.nix
            ./hardware-configuration.nix
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            musnix.nixosModules.musnix
          ];
          specialArgs = { inherit inputs; };
        };

        foxglove = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            disko.nixosModules.disko
            ./foxglove/configuration.nix
            ./foxglove/hardware-configuration.nix
            sops-nix.nixosModules.sops
          ];
        };

      };
    };
}
