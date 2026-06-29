{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  openssh = {
    enable = mkDefault false;
    settings = {
      PasswordAuthentication = mkDefault false;
      PermitRootLogin = mkDefault "no";
    };
  };
}
