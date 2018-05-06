class profiles::mysql::server {

  $root_password     = lookup('mysql::users::root::password')
  $keystone_password = lookup('mysql::users::keystone::password')
  $glance_password   = lookup('mysql::users::glance::password')
  $neutron_password  = lookup('mysql::users::neutron::password')
  $nova_password     = lookup('mysql::users::nova::password')
  $cinder_password   = lookup('mysql::users::cinder::password')
  $heat_password     = lookup('mysql::users::heat::password')
  $zaqar_password    = lookup('mysql::users::zaqar::password')
  $zun_password      = lookup('mysql::users::zun::password')
  $gnocchi_password  = lookup('mysql::users::gnocchi::password')
  $barbican_password = lookup('mysql::users::barbican::password')
  $senlin_password   = lookup('mysql::users::senlin::password')
  $magnum_password   = lookup('mysql::users::magnum::password')

  class { '::mysql::server':
    package_name       => 'mariadb-server',
    service_name       => 'mysql',
    root_password      => $root_password,
    override_options   => {
      mysqld => {
        'bind-address' => '0.0.0.0',
        'log-error'    => '/var/log/mysql/mariadb.log',
        'pid-file'     => '/var/run/mysqld/mysqld.pid',
      },
      mysqld_safe => {
        'log-error' => '/var/log/mysql/mariadb.log',
      },
    },
  }
  contain ::mysql::server

  class { '::mysql::client':
    package_name => 'mariadb-client',
  }
  contain ::mysql::client

  cubbystack::functions::create_mysql_db { 'keystone':
    user     => 'keystone',
    password => $keystone_password,
    host     => '%',
  }

  cubbystack::functions::create_mysql_db { 'glance':
    user     => 'glance',
    password => $glance_password,
    host     => '%',
  }

  cubbystack::functions::create_mysql_db { 'neutron':
    user     => 'neutron',
    password => $neutron_password,
    host     => '%',
  }

  cubbystack::functions::create_mysql_db { 'nova':
    user     => 'nova',
    password => $nova_password,
    host     => '%',
  }

  cubbystack::functions::create_mysql_db { 'nova_api':
    user     => 'nova',
    password => $nova_password,
    host     => '%',
  }

  cubbystack::functions::create_mysql_db { 'nova_cell0':
    user     => 'nova',
    password => $nova_password,
    host     => '%',
  }

  cubbystack::functions::create_mysql_db { 'cinder':
    user     => 'cinder',
    password => $cinder_password,
    host     => '%',
  }

  cubbystack::functions::create_mysql_db { 'heat':
    user     => 'heat',
    password => $heat_password,
    host     => '%',
  }

  cubbystack::functions::create_mysql_db { 'zaqar':
    user     => 'zaqar',
    password => $zaqar_password,
    host     => '%',
  }

  cubbystack::functions::create_mysql_db { 'zun':
    user     => 'zun',
    password => $zun_password,
    host     => '%',
  }

  cubbystack::functions::create_mysql_db { 'gnocchi':
    user     => 'gnocchi',
    password => $gnocchi_password,
    host     => '%',
  }

  cubbystack::functions::create_mysql_db { 'barbican':
    user     => 'barbican',
    password => $barbican_password,
    host     => '%',
  }

  cubbystack::functions::create_mysql_db { 'senlin':
    user     => 'senlin',
    password => $senlin_password,
    host     => '%',
  }

  cubbystack::functions::create_mysql_db { 'magnum':
    user     => 'magnum',
    password => $magnum_password,
    host     => '%',
  }
}
