class roles::gnocchi {
  contain profiles::common::dotfiles
  contain profiles::openstack::common
  contain profiles::openstack::gnocchi
}
