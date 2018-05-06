class roles::zaqar {
  contain profiles::common::dotfiles
  contain profiles::openstack::common
  contain profiles::openstack::zaqar
}
