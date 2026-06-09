{ lib, config, ... }: {
  nixpkgs.config = {
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        # declare allowed unfree packages here
        "1password"
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
        "modrinth-app"
        "modrinth-app-unwrapped"
        "vscode"
        "blender"
        "vcv-rack"
        "bitwig-studio"
        "roomeqwizard"
        "obsidian"
        "discord"
        "spotify"
      ];
  };
  nix = {
    settings = {
      # this option is not in search, but documented here:
      # https://nix.dev/manual/nix/2.34/command-ref/conf-file.html#conf-secret-key-files
      secret-key-files = [ config.sops.secrets."pyrit/binary-cache/private".path ];
    };
  };
}
