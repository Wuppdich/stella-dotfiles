{ ... }:
{
  # nfs ohne kerberos ist nicht transparent. Alle Dateien werden aktuell auf dem Server
  # dem "admin"-Nutzer zugeschrieben.
  fileSystems =
    let
      makeNfsFilesystem = targetDevice: {
        device = "fragment-1:/volume1/" + targetDevice;
        fsType = "nfs";
        options = [
          "nfsvers=4.1"
          "nofail"
          "noauto"
          "x-systemd.automount"
          "x-systemd.idle-timeout=600"
          "comment=x-gvfs-hide"
        ];
      };
    in
    {
      "/home/alice/Bilder" = (makeNfsFilesystem "Personal Files/Pictures");
      "/home/alice/Dokumente" = (makeNfsFilesystem "Personal Files/Documents");
      "/home/alice/Musik" = (makeNfsFilesystem "Music");
      "/home/alice/Videos" = (makeNfsFilesystem "Personal Files/Videos");
      "/home/alice/Downloads" = (makeNfsFilesystem "Personal Files/Downloads");
    };
}
