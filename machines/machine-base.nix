# definitions, that apply to all machines
{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../modules
    ./openssh.nix
    ./nix.nix
    ./pkgs-unstable.nix
    ./private.nix
    ./sops.nix
    ./system.nix
  ];

  time.timeZone = lib.mkDefault "Europe/Berlin";

  garden.lix.enable = true;

  environment.systemPackages = with pkgs; [
    curl
    btop
    hyfetch
    wl-clipboard
  ];

  programs = {
    git = {
      enable = true;
      package = lib.mkDefault pkgs.gitMinimal;
    };
    neovim = {
      enable = true;
      vimAlias = true;
      defaultEditor = true;
    };
  };

}
