{ pkgs, pkgsUnstable, ... }: {
  users.users.alice = {
    isNormalUser = true;
    description = "alice";
    # "wheel" for sudo
    # "dialout" for parallel protocols (moisture sensor)
    # "audio" for realtime audio
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "audio"
    ];
    packages = with pkgs; [
      firefox
      thunderbird
      kitty
      steam
      pkgsUnstable.prusa-slicer
      openscad-unstable
      vscode
      blender
      gimp
      libreoffice
      obsidian
      heroic
      vcv-rack
      pkgsUnstable.itch
      pkgsUnstable.freecad
      prismlauncher
      discord
      vulnix
      lynis
    ];
  };
}
