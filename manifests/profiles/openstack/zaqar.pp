class profiles::openstack::zaqar {
  $settings = lookup('openstack::zaqar::settings')

  package { 'python-pymysql':
    ensure => present,
  }

  package { 'python-redis':
    ensure => present,
  }

  class { 'cubbystack::zaqar':
    settings => $settings,
  }
  contain cubbystack::zaqar

  contain cubbystack::zaqar::api
  contain cubbystack::zaqar::db_sync
}
