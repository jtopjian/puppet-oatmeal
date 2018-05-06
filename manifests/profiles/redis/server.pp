class profiles::redis::server {
  class { '::redis':
    bind => '0.0.0.0',
  }
  contain ::redis
}
