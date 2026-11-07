{
  lib,
  config,
  values,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.garden.remote-luks-key;
in
{
  options.garden.remote-luks-key.enable = mkEnableOption "remote luks key via ssh";

  config = mkIf cfg.enable {
    boot.initrd = {
      # driver found by running lshw
      # kernelModules = [ "r8169" ];
      network = {
        enable = true;
        ssh = {
          enable = true;
          # hostKeys = [ "SETME" ];
          authorizedKeys = with values; [
            coulon.ssh-public.root
            coulon.ssh-public.alice
            pyrit.ssh-public.alice
            pyrit.ssh-public.root
          ];
        };
      };
    };

    # TODO: add handling for static IPs

    # we might need this to load usb attached volumes (on raspberry-pi)
    # boot.initrd.availableKernelModules = [ "usb_storage" ];
  };
}
