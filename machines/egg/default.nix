# bootstrap config
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ../machine-base.nix
    ../../modules/contabo-networking.nix
  ];
}