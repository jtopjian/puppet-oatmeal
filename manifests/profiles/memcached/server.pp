class profiles::memcached::server{
  class { '::memcached':
    max_memory => '5%',
    listen_ip  => '::',
  }
  contain ::memcached
}
