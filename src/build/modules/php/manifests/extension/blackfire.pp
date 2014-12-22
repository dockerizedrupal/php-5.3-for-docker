class php::extension::blackfire {
  require php

  exec { 'mkdir -p /var/run/blackfire':
    path => ['/bin']
  }

  file { '/phpfarm/inst/php-5.3.29/lib/php/extensions/no-debug-non-zts-20090626/blackfire-php-linux_amd64-php-53.so':
    ensure => present,
    source => 'puppet:///modules/php/tmp/blackfire-php-linux_amd64-php-53.so'
  }

  exec { '/bin/su - root -c "curl -s https://packagecloud.io/gpg.key | apt-key add -"': }

  file { '/etc/apt/sources.list.d/blackfire.list':
    ensure => present,
    source => 'puppet:///modules/php/etc/apt/sources.list.d/blackfire.list',
    mode => 644,
    require => Exec['/bin/su - root -c "curl -s https://packagecloud.io/gpg.key | apt-key add -"']
  }

  exec { 'apt-get update':
    path => ['/usr/bin'],
    require => File['/etc/apt/sources.list.d/blackfire.list']
  }

  package {[
      'blackfire-agent'
    ]:
    ensure => present,
    require => Exec['apt-get update']
  }
}
