{ config, pkgs, lib, ... }:
{
  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      # Load nvidia driver for Xorg and Wayland
      videoDrivers = ["nvidia"];
      # Configure keymap in X11
      xkb = {
        layout = "de";
        variant = "";
      };
    };
  };
}