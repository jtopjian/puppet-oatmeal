class profiles::openstack::magnum {
  $settings = lookup('openstack::magnum::settings')

  class { 'cubbystack::magnum':
    settings => $settings,
  }
  contain cubbystack::magnum

  contain cubbystack::magnum::api
  contain cubbystack::magnum::db_sync
  contain cubbystack::magnum::conductor
}
