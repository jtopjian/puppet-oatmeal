class profiles::openstack::glance {
  $settings = lookup('openstack::glance::settings')

  contain cubbystack::glance

  class { 'cubbystack::glance::api':
    settings => $settings,
  }
  contain cubbystack::glance::api

  contain cubbystack::glance::db_sync
}
