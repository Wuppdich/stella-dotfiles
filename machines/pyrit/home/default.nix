{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  fonts.packages =
    with pkgs;
    [
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
    sharedModules = [ (inputs.self + /modules/packages.nix) ];

    users.alice = import ./alice;
  };
}
