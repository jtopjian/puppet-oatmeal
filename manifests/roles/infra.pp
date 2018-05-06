class roles::infra {
  contain profiles::common::dotfiles
  contain profiles::memcached::server
  contain profiles::rabbitmq::server
  contain profiles::mysql::server
  contain profiles::etcd::server
  contain profiles::redis::server
}
