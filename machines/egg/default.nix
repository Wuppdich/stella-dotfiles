# bootstrap config
{
  imports = [
    ./configuration.nix
    ./disk-config.nix
    ./hardware-configuration.nix
    ../machine-base.nix
    ../../modules/contabo-networking.nix
  ];
}