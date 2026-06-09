{ lib, ... }:
{
  imports = [
    ./starship.nix
  ];

  programs.fish = {
    enable = true;
    shellInit = ''
      set fish_greeting
    '';
    shellInitLast = ''
      enable_transience
    '';
  };

  # do not change this without good reason!
  home.stateVersion = "24.05";
}
