{ ... }: {
  services = {
    # Enable sound with pipewire.
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
    pulseaudio.enable = false;
    openssh = {
      enable = false;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    usbmuxd.enable = true; # iPhone
    # Load nvidia driver for Xorg and Wayland
    xserver.videoDrivers = [ "nvidia" ];
    ratbagd.enable = true; # config daemon for HID
  };
}
