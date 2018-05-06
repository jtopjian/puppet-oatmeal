class profiles::common::dotfiles {

  vcsrepo { '/root/.dotfiles':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/jtopjian/dotfiles',
    notify   => Exec['install dotfiles'],
  }

  exec { 'install dotfiles':
    command     => '/bin/bash create.sh',
    cwd         => '/root/.dotfiles',
    refreshonly => true,
  }

}
