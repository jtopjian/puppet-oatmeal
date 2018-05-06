class roles::barbican {
  contain profiles::common::dotfiles
  contain profiles::openstack::common
  contain profiles::openstack::barbican
}
