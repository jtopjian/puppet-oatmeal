class roles::puppetserver {
  contain profiles::common::dotfiles
  contain profiles::puppet::server
}
