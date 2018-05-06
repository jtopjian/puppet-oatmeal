class profiles::openstack::heat {
  $settings = hiera('openstack::heat::settings')

  class { 'cubbystack::heat':
    settings => $settings,
  }
  contain cubbystack::heat

  contain cubbystack::heat::api
  contain cubbystack::heat::api_cfn
  contain cubbystack::heat::engine
  contain cubbystack::heat::db_sync
}
