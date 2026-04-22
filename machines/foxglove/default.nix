{ modulesPath }:
{
  imports = [
    ../machine-base.nix
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./configuration.nix
    ./hardware-configuration.nix
    ./contabo-networking.nix
    ./disk-config.nix
  ];
}
