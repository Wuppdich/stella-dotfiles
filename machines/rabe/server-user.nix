{ config, values, ... }: {
  users.users.server = {
    isNormalUser = true;
    description = "server";
    extraGroups = [
      "wheel"
      "docker"
    ];
    openssh.authorizedKeys.keys = with values; [
      coulon.ssh-public.root
      coulon.ssh-public.alice
      pyrit.ssh-public.alice
      pyrit.ssh-public.root
    ];
    hashedPasswordFile = config.sops.secrets."rabe/passwords/server".path;
  };
}
