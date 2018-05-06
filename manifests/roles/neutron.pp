class roles::neutron {
  contain profiles::common::dotfiles
  contain profiles::openstack::common
  contain profiles::openstack::neutron
}
