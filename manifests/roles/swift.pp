class roles::swift {
  contain profiles::common::dotfiles
  contain profiles::openstack::swift::proxy
}
