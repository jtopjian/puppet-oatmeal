class profiles::puppet::server {

  include puppetdb::master::config

  class { 'puppetdb':
    java_args => {
      '-Xmx' => '512m',
      '-Xms' => '256m',
    }
  }
  contain puppetdb

}
