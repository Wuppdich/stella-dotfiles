{
  config,
  pkgs,
  values,
  ...
}:
{
  users.users."server" = {
    isNormalUser = true;
    description = "server";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];

    openssh.authorizedKeys.keys = with values; [
      coulon.ssh-public.root
      coulon.ssh-public.alice
      pyrit.ssh-public.alice
      pyrit.ssh-public.root
    ];

    hashedPasswordFile = config.sops.secrets."elster/passwords/server".path;
  };
}
