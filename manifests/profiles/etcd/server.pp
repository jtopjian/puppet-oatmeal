class profiles::etcd::server {
  $etcd_version = lookup('etcd::version')

  group { 'etcd':
    ensure => present,
    system => true,
  }

  user { 'etcd':
    ensure     => present,
    gid        => 'etcd',
    home       => '/var/lib/etcd',
    managehome => true,
    system     => true,
    shell      => '/bin/false',
  }

  archive { "/tmp/etcd-${etcd_version}-linux-amd64.tar.gz":
    ensure       => present,
    source       => "https://github.com/coreos/etcd/releases/download/${etcd_version}/etcd-${etcd_version}-linux-amd64.tar.gz",
    extract      => true,
    extract_path => "/tmp",
    creates      => "/tmp/etcd-${etcd_version}-linux-amd64"
  }

  file { '/usr/bin/etcd':
    ensure  => present,
    owner   => 'etcd',
    group   => 'etcd',
    mode    => '0750',
    source  => "file:///tmp/etcd-${etcd_version}-linux-amd64/etcd",
    require => Archive["/tmp/etcd-${etcd_version}-linux-amd64.tar.gz"],
  }

  file { '/usr/bin/etcdctl':
    ensure  => present,
    owner   => 'etcd',
    group   => 'etcd',
    mode    => '0750',
    source  => "file:///tmp/etcd-${etcd_version}-linux-amd64/etcdctl",
    require => Archive["/tmp/etcd-${etcd_version}-linux-amd64.tar.gz"],
  }

  file { '/etc/etcd':
    ensure => directory,
  }

  file { '/etc/systemd/system/etcd.service':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    source  => 'puppet:///files/profiles/etcd/etcd.service',
    require => Archive["/tmp/etcd-${etcd_version}-linux-amd64.tar.gz"],
  }

  class { '::etcd':
    manage_package              => false,
    #config_file_path           => '/etc/default/etcd',
    advertise_client_urls       => "http://${::fqdn}:2379",
    initial_advertise_peer_urls => "http://${::fqdn}:2380",
    listen_peer_urls            => "http://0.0.0.0:2380",
    listen_client_urls          => "http://0.0.0.0:2379",
    initial_cluster             => "default=http://${::fqdn}:2380",
    require                     => File['/etc/systemd/system/etcd.service'],
  }
  contain ::etcd

}
