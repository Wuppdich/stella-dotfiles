{ ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.variables = [ "--all" ];
    configType = "lua";
    extraConfig = builtins.readFile ./hyprland.lua;
  };

  programs = {
    kitty = {
      enable = true;
    };

    fish = {
      enable = true;
      shellInit = ''
        set fish_greeting
      '';
      # shellInitLast = ''
      #   enable_transience
      # '';
    };

    dircolors = {
      enable = true;
      settings = {
        OTHER_WRITABLE = "37;42";
        STICKY = "30;44";
      };
    };
  };

  home = {
    shellAliases = {
      ls = "ls --color=auto --hyperlink=auto";
      ll = "ls -lAh --color=auto --hyperlink=auto";
      less = "less --use-color";
    };
    # do not change this without good reason!
    stateVersion = "24.05";
  };

  fonts.fontconfig.enable = true;
}
