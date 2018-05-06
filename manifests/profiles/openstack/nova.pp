class profiles::openstack::nova {
  $settings = lookup('openstack::nova::settings')

  class { 'cubbystack::nova':
    settings => $settings,
  }
  contain cubbystack::nova

  contain cubbystack::nova::api
  contain cubbystack::nova::conductor
  contain cubbystack::nova::scheduler
  contain cubbystack::nova::placement
  contain cubbystack::nova::vncproxy
  contain cubbystack::nova::consoleauth
  contain cubbystack::nova::db_sync
  contain cubbystack::nova::api_db_sync

}
