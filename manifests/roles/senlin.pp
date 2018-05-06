class roles::senlin {
  contain profiles::common::dotfiles
  contain profiles::openstack::common
  contain profiles::openstack::senlin
}
