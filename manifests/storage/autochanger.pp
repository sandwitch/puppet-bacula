# @summary Configure a Bacula Storage Daemon autochanger
#
# This define creates a storage autochanger declaration.  This informs the
# storage daemon which storage autochangers are available to send client backups to.
#
# @param autochanger_name Bacula configuration for autochanger option 'Name'
# @param changer_device   Bacula configuration for Autochanger option 'Changer Device'
# @param changer_command  Bacula configuration for Autochanger option 'Changer Command'
# @param device           Bacula configuration for Autochanger option 'Device'
# @param conf_dir         Path to bacula configuration directory
#
define bacula::storage::autochanger (
  String                  $autochanger_name     = $name,
  String                  $changer_device       = undef,
  String                  $changer_command      = undef,
  String                  $device               = undef,
  String                  $conf_dir             = $bacula::conf_dir,
) {
  $epp_device_variables = {
    autochanger_name     => $autochanger_name,
    changer_device       => $changer_device,
    changer_command      => $changer_command,
    device               => $device,
  }

  concat::fragment { "bacula-storage-autochanger-${name}":
    target  => "${conf_dir}/bacula-sd.conf",
    content => epp('bacula/bacula-sd-autochanger.epp', $epp_device_variables),
  }
}
