node default {
  file { '/run.sh':
    ensure => present,
    source => '/tmp/build/run.sh',
    mode => 755
  }

  include php
  include php::packages

  exec { 'apt-get update':
    path => ['/usr/bin'],
    before => Class['php::packages']
  }
}
