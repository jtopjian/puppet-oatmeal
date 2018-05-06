class profiles::openstack::cinder {
  $settings = lookup('openstack::cinder::settings')

  class { 'cubbystack::cinder':
    settings => $settings,
  }
  contain cubbystack::cinder

  class { 'cubbystack::cinder::api':
    service_enable => false,
    service_ensure => 'stopped',
  }
  contain cubbystack::cinder::api

  file { '/srv/nfs':
    ensure => directory,
    owner  => 'cinder',
    group  => 'cinder',
  }

  contain cubbystack::cinder::api_wsgi

  contain cubbystack::cinder::scheduler
  contain cubbystack::cinder::volume
  contain cubbystack::cinder::db_sync
  contain cubbystack::cinder::backup

  file { '/etc/cinder/nfs_shares.conf':
    ensure => present,
    owner  => 'cinder',
    group  => 'cinder',
    mode   => '0640',
  }

  file_line { '/etc/cinder/nfs_shares.conf cinder:/srv/nfs':
    path => '/etc/cinder/nfs_shares.conf',
    line => 'cinder:/srv/nfs',
  }
}
