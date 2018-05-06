class profiles::openstack::barbican {
  $settings = lookup('openstack::barbican::settings')

  class { 'cubbystack::barbican':
    settings => $settings,
  }
  contain cubbystack::barbican

  class { 'cubbystack::barbican::api':
    service_enable => false,
    service_ensure => 'stopped',
  }
  contain cubbystack::barbican::api
  contain cubbystack::barbican::api_wsgi

  contain cubbystack::barbican::db_sync
  contain cubbystack::barbican::worker
  contain cubbystack::barbican::listener
}
