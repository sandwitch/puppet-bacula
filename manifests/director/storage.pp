# @summary Configure a Bacula Director Storage resource
#
# This define creates a storage declaration for the director.  This informs the
# director which storage servers are available to send client backups to.
#
# This resource is intended to be used from bacula::storage as an exported
# resource, so that each storage server is available as a configuration on the
# director.
#
# @param address       Bacula director configuration for Storage option 'SDAddress'
# @param port          Bacula director configuration for Storage option 'SDPort'
# @param password      Bacula director configuration for Storage option 'Password'
# @param device_name   Bacula director configuration for Storage option 'Device'
# @param media_type    Bacula director configuration for Storage option 'Media Type'
# @param maxconcurjobs Bacula director configuration for Storage option 'Maximum Concurrent Jobs'
# @param conf_dir      Bacula configuration directory
# @param autochanger      When you use the label command or the add command to create a new Volume, Bacula will also request the Autochanger Slot number
# @param allowcompression This will cause backups jobs running on this storage resource to run without client File Daemon compression
#
define bacula::director::storage (
  String  $address       = $name,
  Integer $port          = 9103,
  String  $password      = 'secret',
  String  $device_name   = "${facts['networking']['fqdn']}-device",
  String  $media_type    = 'File',
  Integer $maxconcurjobs = 1,
  String  $conf_dir      = $bacula::conf_dir,
  Optional[Bacula::Yesno] $autochanger      = undef,
  Optional[Bacula::Yesno] $allowcompression = undef,

) {
  $epp_storage_variables = {
    name          => $name,
    address       => $address,
    port          => $port,
    password      => $password,
    device_name   => $device_name,
    media_type    => $media_type,
    maxconcurjobs => $maxconcurjobs,
    autochanger      => $autochanger,
    allowcompression => $allowcompression,


  }

  concat::fragment { "bacula-director-storage-${name}":
    target  => "${conf_dir}/conf.d/storage.conf",
    content => epp('bacula/bacula-dir-storage.epp', $epp_storage_variables),
  }
}
