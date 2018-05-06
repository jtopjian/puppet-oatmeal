class profiles::openstack::common {
  $keystone_host  = lookup('openstack::keystone::host')
  $admin_password = lookup('openstack::users::admin::password')
  $demo_password = lookup('openstack::users::admin::password')

  cubbystack::functions::create_openrc { '/root/openrc':
    keystone_host  => $keystone_host,
    admin_password => $admin_password,
  }

  cubbystack::functions::create_openrc { '/root/demorc':
    keystone_host  => $keystone_host,
    admin_password => $demo_password,
    user           => 'demo',
    project        => 'demo',
  }

  $clients = [
    'python-openstackclient',
    'python-heatclient',
    'python-zaqarclient',
    'python-zunclient',
    'python-barbicanclient',
    'python-magnumclient'
  ]
  package { $clients:
    ensure => present,
  }
}
