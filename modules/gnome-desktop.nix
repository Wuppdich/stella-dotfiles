{ config, lib, options, ... }:
with lib;
let
  cfg = config.garden.gnome;
in
{
  options.garden.gnome.enable = mkEnableOption "gnome-desktop";

  config = mkIf cfg.enable {
    services = {
      xserver = {
        # Enable the X11 windowing system.
        enable = true;
      };
      # Enable the GNOME Desktop Environment.
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };
  };
}
