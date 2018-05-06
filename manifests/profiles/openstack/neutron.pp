class profiles::openstack::neutron {
  $settings             = lookup('openstack::neutron::settings')
  $dhcp_settings        = lookup('openstack::neutron::dhcp::settings')
  $l3_settings          = lookup('openstack::neutron::l3::settings')
  $metadata_settings    = lookup('openstack::neutron::metadata::settings')
  $ml2_settings         = lookup('openstack::neutron::ml2::settings')
  $linuxbridge_settings = lookup('openstack::neutron::linuxbridge::settings')
  $fwaas_settings       = lookup('openstack::neutron::fwaas::settings')
  $lbaas_settings       = lookup('openstack::neutron::lbaas::settings')

  class { 'cubbystack::neutron':
    settings => $settings,
  }
  contain cubbystack::neutron

  contain cubbystack::neutron::server

  contain cubbystack::neutron::db_sync

  class { 'cubbystack::neutron::dhcp':
    settings => $dhcp_settings,
  }
  contain cubbystack::neutron::dhcp

  class { 'cubbystack::neutron::l3':
    settings => $l3_settings,
  }
  contain cubbystack::neutron::l3

  class { 'cubbystack::neutron::metadata':
    settings => $metadata_settings,
  }
  contain cubbystack::neutron::metadata

  class { 'cubbystack::neutron::plugins::ml2':
    settings => $ml2_settings,
  }
  contain cubbystack::neutron::plugins::ml2

  class { 'cubbystack::neutron::plugins::linuxbridge':
    settings => $linuxbridge_settings,
  }
  contain cubbystack::neutron::plugins::ml2

  class { 'cubbystack::neutron::fwaas':
    settings => $fwaas_settings,
  }
  contain cubbystack::neutron::plugins::ml2

  #class { 'cubbystack::neutron::lbaas':
  #  settings          => $neutron_lbaas_settings,
  #  require           => Class['haproxy'],
  #}
	#contain cubbystack::neutron::lbaas

  # Replace ip_conntrack.py until an official release is out
  file { '/usr/lib/python2.7/dist-packages/neutron/agent/linux/ip_conntrack.py':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///files/profiles/openstack/neutron/ip_conntrack.py',
  }

  File['/usr/lib/python2.7/dist-packages/neutron/agent/linux/ip_conntrack.py'] ~> Service<| tag == 'cubbystack_neutron' |>

}
