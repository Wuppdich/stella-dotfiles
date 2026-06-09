{ pkgs, ... }: {
  fonts = {
    fontconfig.enable = true;
    fontDir.enable = true;
    enableDefaultPackages = true;
    # install specific fonts
    packages = with pkgs; [
      (google-fonts.override {
        fonts = [
          "Pathway Gothic One"
          "Roboto"
        ];
      })
      nerd-fonts.dejavu-sans-mono
      nerd-fonts.symbols-only
      nerd-fonts.noto
      nerd-fonts.droid-sans-mono
      noto-fonts
      adwaita-fonts
    ];
  };
}
