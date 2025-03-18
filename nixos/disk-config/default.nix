{ mergedSetup, ... }:
{
  import = if mergedSetup.disk.isLVM then [ ./lvm.nix ] else [ ./classic.nix ];
}
