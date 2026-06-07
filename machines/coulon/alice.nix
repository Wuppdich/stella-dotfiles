{
  pkgs,
  pkgsUnstable,
  ...
}:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
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
      "wireshark"
      "docker"
      "lp"
    ];
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
      tuba
      hyprlauncher
      kdePackages.dolphin
      # programmierung
      kitty
      nix-output-monitor
      vscode
      nil
      nixfmt
      sops
      age
      # gaming
      steam
      lutris
      ludusavi
      heroic
      itch
      prismlauncher
      # CGI/CAD
      pkgsUnstable.prusa-slicer
      (blender.override {
        cudaSupport = true;
      })
      # blend file thumbnailer
      (pkgs.writeTextFile {
        name = "blender thumbnails";
        text = ''
          [Thumbnailer Entry]
          TryExec=blender-thumbnailer
          Exec=blender-thumbnailer %i %o
          MimeType=application/x-blender;
        '';
        destination = "/share/thumbnailers/blender.thumbnailer";
      })
      freecad
      gimp
      pkgsUnstable.darktable
      vlc
      kicad
      pkgsUnstable.davinci-resolve
      kdePackages.kdenlive
      # audio
      spotify
      rhythmbox
      pkgsUnstable.vcv-rack
      ardour
      pkgsUnstable.bitwig-studio
      audacity
      plugdata
      roomeqwizard
      # office
      (libreoffice.override {
        unwrapped = (
          libreoffice-still.unwrapped.override {
            langs = [
              "de"
              "en-GB"
              "en-US"
            ];
            hunspell = (
              hunspell.override {
                hunspellDicts = with hunspellDicts; [
                  de_DE
                  en_US
                  en_GB-ize
                ];
              }
            );
            withHelp = false;
            withJava = false;
          }
        );
      })
      hyphenDicts.de_DE
      hyphenDicts.en_US
      obsidian
      bisq2
    ];
  };
}
