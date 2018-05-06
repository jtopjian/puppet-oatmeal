class roles::workstation {
  contain profiles::common::dotfiles

  class { 'python':
    version    => 'system',
    pip        => true,
    dev        => true,
    virtualenv => true,
  }
  contain python

  $clients = [
    'python-openstackclient',
    'python-heatclient',
    'python-zaqarclient',
    'python-zunclient',
    'python-barbicanclient',
    'python-magnumclient',
    'python-octaviaclient',
    'python-manilaclient',
    'python-designateclient',
  ]
  package { $clients:
    ensure => present,
  }

  contain cubbystack::gnocchi::client
  contain cubbystack::senlin::client
}
