class roles::heat {
  contain profiles::common::dotfiles
  contain profiles::openstack::common
  contain profiles::openstack::heat
}
