class profiles::openstack::swift::proxy {
  $settings = lookup('openstack::swift::proxy::settings')

  file { '/etc/swift':
    ensure  => directory,
    owner   => 'swift',
    group   => 'swift',
    recurse => true,
  }

  file { '/mnt/sdb1':
    ensure  => directory,
    owner   => 'swift',
    group   => 'swift',
    recurse => true,
  }

  $settings.each |$setting, $value| {
    cubbystack_config { "/etc/swift/proxy-server.conf: ${setting}":
      value  => $value,
      tag    => ['cubbystack_openstack', 'cubbystack_swift'],
      notify => Exec['restart swift'],
    }
  }

  exec { 'restart swift':
    path        => ['/usr/local/bin'],
    command     => 'swift-init all restart',
    refreshonly => true,
  }
}
