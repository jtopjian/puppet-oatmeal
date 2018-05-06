class roles::zcompute {
  contain profiles::common::dotfiles
  contain profiles::openstack::common
  contain profiles::openstack::linuxbridge_agent
  contain profiles::openstack::zcompute
}
