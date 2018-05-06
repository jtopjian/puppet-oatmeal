class profiles::openstack::senlin {
  $settings = lookup('openstack::senlin::settings')

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

  group { 'senlin':
    ensure => present,
    system => true,
  }

  user { 'senlin':
    ensure     => present,
    gid        => 'senlin',
    home       => '/var/lib/senlin',
    managehome => true,
    system     => true,
    shell      => '/bin/false',
  }

  class { 'cubbystack::senlin':
    settings => $settings,
  }
  contain cubbystack::senlin

  contain cubbystack::senlin::db_sync
  contain cubbystack::senlin::api
  contain cubbystack::senlin::engine
  contain cubbystack::senlin::client
}
