{ ... }:
{
  # this is only temp
  fileSystems."/home/alice/disk" = {
    device = "fragment-1:/volume1/Personal Files";
    fsType = "nfs";
    options = [
      "nfsvers=4.1"
    ];
  };
  services.gvfs.enable = true;
}
