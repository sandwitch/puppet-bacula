# @summary Configure a Bacula Storage Daemon Device
#
# This define creates a storage device declaration.  This informs the
# storage daemon which storage devices are available to send client backups to.
#
# @param device_name     Bacula director configuration for Device option 'Name'
# @param media_type      Bacula director configuration for Device option 'Media Type'
# @param device          Bacula director configuration for Device option 'Archive Device'
# @param label_media     Bacula director configuration for Device option 'LabelMedia'
# @param random_access   Bacula director configuration for Device option 'Random Access'
# @param automatic_mount Bacula director configuration for Device option 'AutomaticMount'
# @param removable_media Bacula director configuration for Device option 'RemovableMedia'
# @param always_open     Bacula director configuration for Device option 'AlwaysOpen'
# @param maxconcurjobs   Bacula director configuration for Device option 'Maximum Concurrent Jobs'
# @param conf_dir        Path to bacula configuration directory
# @param device_mode     Unix mode of the Archive Device directory
# @param device_owner    Owner of the Archive Device directory
# @param device_seltype  SELinux type for the device
# @param director_name   Name of the Director allowed to connect to the Storage daemon
# @param group           The posix group for bacula
# @param drive_index
# @param volume_poll_interval
# @param autochanger
# @param maximum_spool_size
# @param maximum_file_size
# @param spool_directory
# @param alert_command
##TODO: document the above parameters!
#
define bacula::storage::device (
  String           $device_name     = $name,
  String           $media_type      = 'File',
  String           $device          = '/bacula',
  Bacula::Yesno    $label_media     = true,
  Bacula::Yesno    $random_access   = true,
  Bacula::Yesno    $automatic_mount = true,
  Bacula::Yesno    $removable_media = false,
  Bacula::Yesno    $always_open     = false,
  Integer          $maxconcurjobs   = 1,
  String           $conf_dir        = $bacula::conf_dir,
  Stdlib::Filemode $device_mode     = '0770',
  String           $device_owner    = $bacula::bacula_user,
  String           $device_seltype  = $bacula::device_seltype,
  String           $director_name   = $bacula::director_name,
  String           $group           = $bacula::bacula_group,
  Optional[Integer]       $drive_index          = undef,
  Optional[Integer]       $volume_poll_interval = undef,
  Optional[Bacula::Yesno] $autochanger          = undef,
  Optional[String]        $maximum_spool_size   = undef,
  Optional[String]        $maximum_file_size    = undef,
  Optional[String]        $spool_directory      = undef,
  Optional[String]        $alert_command        = undef,
) {
  $epp_device_variables = {
    device_name          => $device_name,
    media_type           => $media_type,
    device               => $device,
    label_media          => $label_media,
    random_access        => $random_access,
    automatic_mount      => $automatic_mount,
    removable_media      => $removable_media,
    always_open          => $always_open,
    maxconcurjobs        => $maxconcurjobs,
    drive_index          => $drive_index,
    volume_poll_interval => $volume_poll_interval,
    autochanger          => $autochanger,
    maximum_spool_size   => $maximum_spool_size,
    maximum_file_size    => $maximum_file_size,
    spool_directory      => $spool_directory,
    alert_command        => $alert_command,

  }

  concat::fragment { "bacula-storage-device-${name}":
    target  => "${conf_dir}/bacula-sd.conf",
    content => epp('bacula/bacula-sd-device.epp', $epp_device_variables),
  }

  if $media_type =~ '^File' {
    file { $device:
      ensure  => directory,
      owner   => $device_owner,
      group   => $group,
      mode    => $device_mode,
      seltype => $device_seltype,
    }
  }
}
