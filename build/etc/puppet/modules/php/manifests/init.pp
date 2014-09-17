class php {
  include php::phpfarm
  include php::supervisor
  include php::xdebug

  file { 'Copy custom options (CGI)':
    path => '/phpfarm/src/custom-options-5.3.28.sh',
    ensure => present,
    source => '/tmp/build/phpfarm/src/custom-options-5.3.28-cgi.sh',
    mode => 755,
    require => Class['php::phpfarm']
  }

  exec { 'Compile PHP (CGI)':
    command => '/phpfarm/src/compile.sh 5.3.28',
    timeout => 0,
    require => File['Copy custom options (CGI)']
  }

  file { 'Copy custom options (FPM)':
    path => '/phpfarm/src/custom-options-5.3.28.sh',
    ensure => present,
    source => '/tmp/build/phpfarm/src/custom-options-5.3.28.sh',
    mode => 755,
    require => Exec['Compile PHP (CGI)']
  }

  exec { 'Compile PHP (FPM)':
    command => '/phpfarm/src/compile.sh 5.3.28',
    timeout => 0,
    require => File['Copy custom options (FPM)']
  }

  file { '/phpfarm/inst/php-5.3.28/etc/php-fpm.conf':
    ensure => present,
    source => '/tmp/build/phpfarm/inst/php-5.3.28/etc/php-fpm.conf',
    mode => 644,
    require => Exec['Compile PHP (FPM)']
  }

  file { '/phpfarm/inst/php-5.3.28/lib/php.ini':
    ensure => present,
    source => '/tmp/build/phpfarm/inst/php-5.3.28/lib/php.ini',
    mode => 644,
    require => Exec['/phpfarm/src/compile.sh 5.3.28']
  }

  file { '/etc/profile.d/phpfarm.sh':
    ensure => present,
    source => '/tmp/build/etc/profile.d/phpfarm.sh',
    mode => 755,
    require => Exec['/phpfarm/src/compile.sh 5.3.28']
  }

  exec { '/bin/bash -l -c "switch-phpfarm 5.3.28"':
    require => File['/etc/profile.d/phpfarm.sh']
  }
}
