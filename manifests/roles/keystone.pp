class roles::keystone {
  contain profiles::common::dotfiles
  contain profiles::openstack::common
  contain profiles::openstack::keystone
}
