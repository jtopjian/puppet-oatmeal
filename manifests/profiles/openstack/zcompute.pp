class profiles::openstack::zcompute {
  $zun_settings   = lookup('openstack::zun::settings')
  $kuryr_settings = lookup('openstack::kuryr::settings')

  package { 'python-memcache':
    ensure => present,
  }

  package { 'python-pymysql':
    ensure => present,
  }

  package { 'pciutils':
    ensure => present,
  }

  class { 'python':
    version    => 'system',
    pip        => true,
    dev        => true,
    virtualenv => true,
  }
  contain python

  python::pip { 'oslo.rootwrap': }

  group { 'zun':
    ensure => present,
    system => true,
  }

  user { 'zun':
    ensure     => present,
    gid        => 'zun',
    home       => '/var/lib/zun',
    managehome => true,
    system     => true,
    shell      => '/bin/false',
  }

  group { 'kuryr':
    ensure => present,
    system => true,
  }

  user { 'kuryr':
    ensure     => present,
    gid        => 'kuryr',
    home       => '/var/lib/kuryr',
    managehome => true,
    system     => true,
    shell      => '/bin/false',
  }

  file { '/etc/apt/apt.conf.d/02docker':
    ensure  => present,
    content => "Acquire::http::Proxy { download.docker.com DIRECT; };\n",
  }

  class { 'docker':
    service_overrides_template => false,
  }
  contain docker

  $ip = $facts['networking']['ip']
  $docker_conf = @(END)
    [Service]
    ExecStart=
    ExecStart=/usr/bin/dockerd --group zun -H tcp://<%= $ip -%>:2375 -H unix:///var/run/docker.sock --cluster-store etcd://infra:2379
    | END

  file { '/etc/systemd/system/docker.service.d/docker.conf':
    ensure  => present,
    content => inline_epp($docker_conf, { 'ip' => $ip }),
    notify  => Exec['restart docker'],
  }

  class { 'cubbystack::kuryr':
    settings => $kuryr_settings,
    notify   => Exec['restart docker'],
  }
  contain cubbystack::kuryr

  class { 'cubbystack::zun':
    settings => $zun_settings,
  }
  contain cubbystack::zun
  contain cubbystack::zun::compute

  exec { 'restart docker':
    path        => ['/bin', '/usr/bin'],
    command     => 'systemctl daemon-reload && systemctl restart docker',
    refreshonly => true,
  }
}
