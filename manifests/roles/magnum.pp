class roles::magnum {
  contain profiles::common::dotfiles
  contain profiles::openstack::common
  contain profiles::openstack::magnum
}
