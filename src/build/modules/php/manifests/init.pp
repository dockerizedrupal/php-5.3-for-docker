class php {
  require php::packages
  require php::phpfarm
  require php::supervisor

  file { '/phpfarm/src/php-5.3.29.tar.gz':
    ensure => present,
    source => 'puppet:///modules/php/phpfarm/src/php-5.3.29.tar.gz'
  }

  exec { 'tar xzf php-5.3.29.tar.gz':
    cwd => '/phpfarm/src',
    path => ['/bin'],
    require => File['/phpfarm/src/php-5.3.29.tar.gz']
  }

  exec { 'Compile PHP (CGI)':
    command => '/bin/bash -c "cp /src/build/modules/php/files/phpfarm/src/custom/options-5.3.29-cgi.sh /phpfarm/src/custom/options-5.3.29.sh && /phpfarm/src/main.sh 5.3.29"',
    timeout => 0,
    require => Exec['tar xzf php-5.3.29.tar.gz']
  }

  exec { 'Compile PHP (FPM)':
    command => '/bin/bash -c "cp /src/build/modules/php/files/phpfarm/src/custom/options-5.3.29-fpm.sh /phpfarm/src/custom/options-5.3.29.sh && /phpfarm/src/main.sh 5.3.29"',
    timeout => 0,
    require => Exec['Compile PHP (CGI)']
  }

  exec { 'rm -rf /phpfarm/src/php-5.3.29':
    path => ['/bin'],
    require => Exec['Compile PHP (FPM)']
  }

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
