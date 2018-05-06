class profiles::rabbitmq::server{
  $keystone_password = lookup('rabbitmq::users::keystone::password')
  $glance_password   = lookup('rabbitmq::users::glance::password')
  $neutron_password  = lookup('rabbitmq::users::neutron::password')
  $nova_password     = lookup('rabbitmq::users::nova::password')
  $cinder_password   = lookup('rabbitmq::users::cinder::password')
  $heat_password     = lookup('rabbitmq::users::heat::password')
  $zun_password      = lookup('rabbitmq::users::zun::password')
  $barbican_password = lookup('rabbitmq::users::barbican::password')
  $senlin_password   = lookup('rabbitmq::users::senlin::password')
  $magnum_password   = lookup('rabbitmq::users::magnum::password')

  class { '::rabbitmq':
    repos_ensure => true,
  }
  contain ::rabbitmq

  rabbitmq_vhost { 'openstack':
    ensure => present,
  }

  rabbitmq_user { 'keystone':
    password => $keystone_password,
  }

  rabbitmq_user_permissions { 'keystone@openstack':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  rabbitmq_user { 'glance':
    password => $glance_password,
  }

  rabbitmq_user_permissions { 'glance@openstack':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  rabbitmq_user { 'neutron':
    password => $neutron_password,
  }

  rabbitmq_user_permissions { 'neutron@openstack':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  rabbitmq_user { 'nova':
    password => $nova_password,
  }

  rabbitmq_user_permissions { 'nova@openstack':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  rabbitmq_user { 'cinder':
    password => $cinder_password,
  }

  rabbitmq_user_permissions { 'cinder@openstack':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  rabbitmq_user { 'heat':
    password => $heat_password,
  }

  rabbitmq_user_permissions { 'heat@openstack':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  rabbitmq_user { 'zun':
    password => $zun_password,
  }

  rabbitmq_user_permissions { 'zun@openstack':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  rabbitmq_user { 'barbican':
    password => $barbican_password,
  }

  rabbitmq_user_permissions { 'barbican@openstack':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  rabbitmq_user { 'senlin':
    password => $senlin_password,
  }

  rabbitmq_user_permissions { 'senlin@openstack':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  rabbitmq_user { 'magnum':
    password => $magnum_password,
  }

  rabbitmq_user_permissions { 'magnum@openstack':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }
}
