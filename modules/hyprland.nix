{ config, lib, ... }:
with lib;
let
  cfg = config.garden.hyprland;
in
{
  options.garden.hyprland.enable = mkEnableOption "hyprland";

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
}
