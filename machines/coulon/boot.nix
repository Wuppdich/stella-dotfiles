{ config, ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Setup keyfile (TODO: do this with sops?)
    initrd = {
      secrets = {
        "/crypto_keyfile.bin" = null;
      };
      # Enable swap on luks
      luks.devices."luks-9c5a0fd5-c5a3-4376-a9ca-abd0e7a6a9af" = {
        device = "/dev/disk/by-uuid/9c5a0fd5-c5a3-4376-a9ca-abd0e7a6a9af";
        keyFile = "/crypto_keyfile.bin";
      };
    };
    extraModulePackages = with config.boot.kernelPackages; [ nct6687d ];
    # nct6687d enables MSI Motherboard sensors
    kernelModules = [ "nct6687" ];
  };

}
