class roles::zun {
  contain profiles::common::dotfiles
  contain profiles::openstack::common
  contain profiles::openstack::zun
}
