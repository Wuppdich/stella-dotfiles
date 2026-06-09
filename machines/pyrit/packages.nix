{ pkgs, ... }: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    lm_sensors
    # blend file thumbnailer
    (pkgs.writeTextFile {
      name = "blender thumbnails";
      text = ''
        [Thumbnailer Entry]
        TryExec=blender-thumbnailer
        Exec=blender-thumbnailer %i %o
        MimeType=application/x-blender;
      '';
      destination = "/share/thumbnailers/blender.thumbnailer";
    })
  ];
}
