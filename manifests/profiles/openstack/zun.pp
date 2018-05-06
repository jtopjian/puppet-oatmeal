class profiles::openstack::zun {
  $settings = lookup('openstack::zun::settings')

  package { 'python-pymysql':
    ensure => present,
  }

  package { 'python-memcache':
    ensure => present,
  }

  class { 'python':
    version    => 'system',
    pip        => true,
    dev        => true,
    virtualenv => true,
  }
  contain python

  group { 'zun':
    ensure => present,
    system => true,
  }

  user { 'zun':
    ensure     => present,
    gid        => 'zun',
    home       => '/var/lib/zun',
    managehome => true,
    system     => true,
    shell      => '/bin/false',
  }

  class { 'cubbystack::zun':
    settings => $settings,
  }
  contain cubbystack::zun

  contain cubbystack::zun::db_sync
  contain cubbystack::zun::api
  contain cubbystack::zun::wsproxy
}
