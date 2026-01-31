{ config, pkgs, lib, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alice = {
    isNormalUser = true;
    description = "alice";
    # "wheel" for sudo
    # "dialout" for parallel protocols (moisture sensor)
    # "audio" for realtime audio
    extraGroups = [ "networkmanager" "wheel" "dialout" "audio" "wireshark" "docker" ];
    packages = with pkgs; [
      # internet
      firefox
      wireshark
      # desktop entries to launch firefox with custom profiles
      (pkgs.makeDesktopItem {
        name = "youtube";
        desktopName = "YouTube";
        exec = "firefox -P youtube-machine";
      })
      (pkgs.makeDesktopItem {
        name = "twitch";
        desktopName = "Twitch";
        exec = "firefox -P twitch-machine";
      })
      thunderbird
      tor-browser
      vesktop
      signal-desktop
      # programmierung
      kitty
      nix-output-monitor
      vscode
      # gaming
      steam
      lutris
      ludusavi
      heroic
      itch
      prismlauncher
      # CGI/CAD
      unstable.prusa-slicer
      (blender.override {
        cudaSupport = true;
      })
      freecad
      gimp
      unstable.darktable
      vlc
      kicad
      unstable.davinci-resolve
      kdePackages.kdenlive
      # audio
      spotify
      rhythmbox
      unstable.vcv-rack
      ardour
      unstable.bitwig-studio
      audacity
      plugdata
      roomeqwizard
      # office
      libreoffice
      hunspellDicts.de_DE
      hunspellDicts.en_US
      hunspellDicts.en_GB-ize
      hyphenDicts.de_DE
      hyphenDicts.en_US
      obsidian
      bisq2
    ];
  };
}