class profiles::openstack::gnocchi {
  $settings = lookup('openstack::gnocchi::settings')

  class { 'python':
    version    => 'system',
    pip        => true,
    dev        => true,
    virtualenv => true,
  }
  contain python

  group { 'gnocchi':
    ensure  => present,
    system  => true,
  }

  user { 'gnocchi':
    ensure     => present,
    gid        => 'gnocchi',
    home       => '/var/lib/gnocchi',
    managehome => true,
    system     => true,
    shell      => '/bin/false',
  }

  package { 'python-memcache':
    ensure => present,
  }

  package { 'python-redis':
    ensure => present,
  }

  contain apache
  contain apache::mod::wsgi

  class { 'cubbystack::gnocchi':
    settings => $settings,
    version  => '4.2.4',
  }
  contain cubbystack::gnocchi

  contain cubbystack::gnocchi::client
  contain cubbystack::gnocchi::db_sync
  contain cubbystack::gnocchi::metricd
  contain cubbystack::gnocchi::api
}
