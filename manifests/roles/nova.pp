class roles::nova {
  contain profiles::common::dotfiles
  contain profiles::openstack::common
  contain profiles::openstack::nova
}
