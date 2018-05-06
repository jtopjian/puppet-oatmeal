class profiles::openstack::linuxbridge_agent {
  $neutron_settings = lookup('openstack::neutron::settings')
  $lb_settings      = lookup('openstack::neutron::linuxbridge::settings')
  $ml2_settings     = lookup('openstack::neutron::ml2::settings')

  class { 'cubbystack::neutron':
    settings => $neutron_settings,
  }
  contain cubbystack::neutron

  class { 'cubbystack::neutron::plugins::ml2':
    settings => $ml2_settings,
  }
  contain cubbystack::neutron::plugins::ml2

  class { 'cubbystack::neutron::plugins::linuxbridge':
    settings => $lb_settings,
  }
  contain cubbystack::neutron::plugins::linuxbridge

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
