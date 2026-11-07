{ ... }:
{
  imports = [
    ./contabo-networking.nix
    ./gnome-desktop.nix
    ./lix.nix
    ./hyprland.nix
    ./packages.nix
    ./remote-luks-key.nix
    ./fail2ban.nix
  ];
}
