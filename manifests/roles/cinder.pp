class roles::cinder {
  contain profiles::common::dotfiles
  contain profiles::openstack::common
  contain profiles::openstack::cinder
}
