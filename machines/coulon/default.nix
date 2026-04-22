{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ../machine-base.nix
    ./fix.nix
    ./nix.nix
    ./locale.nix
    ./nvidia.nix
    ./alice.nix
    ./home-manager.nix
    ./gdm.nix
    ./nvf.nix
  ];
}