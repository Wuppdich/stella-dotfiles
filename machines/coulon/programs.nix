{ pkgs, ... }: {
  programs = {
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    fish.enable = true;
    starship.enable = true;
    # https://nix-community.github.io/home-manager/index.xhtml#_why_do_i_get_an_error_message_about_literal_ca_desrt_dconf_literal_or_literal_dconf_service_literal
    # dconf.enable = true;

    _1password-gui = {
      enable = true;
      # allow unlocking with user password
      polkitPolicyOwners = [ "alice" ];
    };
    firefox.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
    git.package = pkgs.git;
    direnv.enable = true;
    wireshark.enable = true;
  };
}
