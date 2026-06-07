# i straight up stole this from isabelroses
{
  lib,
  config,
  _class,
  ...
}:
let
  packages = config.garden.packages;
  inherit (lib.options) mkOption;
  inherit (lib.types) lazyAttrsOf package;
in
{
  options.garden.packages = mkOption {
    type = lazyAttrsOf package;
    default = { };
    description = ''
      will either add those packages to home.packages in home-manager
      or environment.systemPackages in nixos
    '';
  };

  config =
    if _class == "homeManager" then
      { home.packages = builtins.attrValues packages; }
    else
      { environment.systemPackages = builtins.attrValues packages; };
}
