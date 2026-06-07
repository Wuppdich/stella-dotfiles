{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.garden.hyprland;
in
{
  options.garden.hyprland.enable = mkEnableOption "hyprland";

  config = mkIf cfg.enable {
    programs = {
      hyprland = {
        enable = true;

        # systemd integration
        withUWSM = true;

        xwayland.enable = true;
      };

      # configuration db for gnome tools
      dconf.enable = true;

      # gnome keyring management
      seahorse.enable = true;
    };

    services = {
      # login GUI. launches hyprland
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };

      # we use gnome-settings-daemon's udev rules
      udev.packages = [ pkgs.gnome-settings-daemon ];

      gnome.gnome-keyring.enable = true;

      # notification daemon
      dunst.enable = true;
    };

    security = {
      # policy management
      polkit.enable = true;

      # authentication agent for polkit (aka password prompt)
      soteria.enable = true;
    };
  };
}
