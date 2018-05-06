class profiles::openstack::compute {
  $nova_settings = lookup('openstack::nova::settings')

  package { 'nfs-common':
    ensure => present,
  }

  class { 'cubbystack::nova':
    settings => $nova_settings,
  }
  contain cubbystack::nova

  contain cubbystack::nova::compute

  class { 'cubbystack::nova::compute::libvirt':
    libvirt_type => 'qemu',
  }
  contain cubbystack::nova::compute::libvirt
}
