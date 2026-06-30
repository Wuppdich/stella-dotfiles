{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  services.openssh = {
    enable = mkDefault false;
    settings = {
      PasswordAuthentication = mkDefault false;
      PermitRootLogin = mkDefault "no";
    };
  };
}
