{ ... }: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Setup keyfile
    initrd = {
      secrets = {
        "/crypto_keyfile.bin" = null;
      };
      # Enable swap on luks
      luks.devices."luks-75097e1b-c10e-45f7-85bd-294e80ea40d0" = {
        device = "/dev/disk/by-uuid/75097e1b-c10e-45f7-85bd-294e80ea40d0";
        keyFile = "/crypto_keyfile.bin";
      };
    };
  };
}
