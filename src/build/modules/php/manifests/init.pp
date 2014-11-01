class php {
  require php::packages
  require php::phpfarm
  require php::supervisor

  require php::cgi
  require php::fpm

  file { '/phpfarm/inst/php-5.3.29/etc/php-fpm.conf':
    ensure => present,
    source => 'puppet:///modules/php/phpfarm/inst/php-5.3.29/etc/php-fpm.conf',
    mode => 644,
    require => Exec['Compile PHP (FPM)']
  }

  file { '/phpfarm/inst/php-5.3.29/lib/php.ini':
    ensure => present,
    source => 'puppet:///modules/php/phpfarm/inst/php-5.3.29/lib/php.ini',
    mode => 644,
    require => Exec['Compile PHP (FPM)']
  }

  exec { '/bin/bash -l -c "switch-phpfarm 5.3.29"':
    require => Exec['Compile PHP (FPM)']
  }
}
