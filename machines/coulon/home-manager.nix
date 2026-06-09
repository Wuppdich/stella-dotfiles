{
  inputs,
  ...
}:
{
  # home manager config
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users.alice = import ./home-alice.nix;
    backupFileExtension = "backup";
  };
}
