class roles::glance {
  contain profiles::common::dotfiles
  contain profiles::openstack::common
  contain profiles::openstack::glance
}
