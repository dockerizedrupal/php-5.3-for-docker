class packages {
  package {[
      'git',
      'curl',
      'build-essential',
      'libxml2-dev',
      'libssl-dev',
      'libbz2-dev',
      'libcurl4-gnutls-dev',
      'libjpeg-dev',
      'libpng12-dev',
      'libmcrypt-dev',
      'libmhash-dev',
      'libmysqlclient-dev',
      'libpspell-dev',
      'autoconf',
      'libcloog-ppl0'
    ]:
    ensure => present
  }
}

class phpfarm {
  include packages

  exec { 'git clone git://git.code.sf.net/p/phpfarm/code phpfarm':
    cwd => '/',
    path => ['/usr/bin'],
    require => Class['packages']
  }
}

class php_supervisor {
  file { '/etc/supervisor/conf.d/php.conf':
    ensure => present,
    source => '/tmp/build/etc/supervisor/conf.d/php.conf'
  }
}

class php_extension_xdebug {
  include php

  exec { 'wget http://xdebug.org/files/xdebug-2.2.5.tgz':
    cwd => '/tmp',
    path => ['/usr/bin'],
    require => Class['php']
  }

  exec { 'tar xzf xdebug-2.2.5.tgz':
    cwd => '/tmp',
    path => ['/bin'],
    require => Exec['wget http://xdebug.org/files/xdebug-2.2.5.tgz']
  }

  exec { 'phpize-5.3.28 xdebug':
    command => '/phpfarm/inst/bin/phpize-5.3.28',
    cwd => '/tmp/xdebug-2.2.5',
    require => Exec['tar xzf xdebug-2.2.5.tgz']
  }

  exec { '/bin/bash -l -c "cd /tmp/xdebug-2.2.5 && ./configure --with-php-config=/phpfarm/inst/bin/php-config-5.3.28"':
    require => Exec['phpize-5.3.28 xdebug']
  }

  exec { '/bin/bash -l -c "cd /tmp/xdebug-2.2.5 && make"':
    require => Exec['/bin/bash -l -c "cd /tmp/xdebug-2.2.5 && ./configure --with-php-config=/phpfarm/inst/bin/php-config-5.3.28"']
  }

  exec { '/bin/bash -l -c "cd /tmp/xdebug-2.2.5 && make install"':
    require => Exec['/bin/bash -l -c "cd /tmp/xdebug-2.2.5 && make"']
  }
}

class php {
  include phpfarm
  include php_supervisor
  include php_extension_xdebug

  exec { 'Compile PHP (CGI)':
    command => '/bin/bash -c "cp /tmp/build/phpfarm/src/custom-options-5.3.28-cgi.sh /phpfarm/src/custom-options-5.3.28.sh && /phpfarm/src/compile.sh 5.3.28"',
    timeout => 0,
    require => Class['phpfarm']
  }

  exec { 'rm -rf /phpfarm/src/php-5.3.28':
    path => ['/bin'],
    require => Exec['Compile PHP (CGI)']
  }

  exec { 'Compile PHP (FPM)':
    command => '/bin/bash -c "cp /tmp/build/phpfarm/src/custom-options-5.3.28-fpm.sh /phpfarm/src/custom-options-5.3.28.sh && /phpfarm/src/compile.sh 5.3.28"',
    timeout => 0,
    require => Exec['rm -rf /phpfarm/src/php-5.3.28']
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
    require => Exec['Compile PHP (FPM)']
  }

  file { '/etc/profile.d/phpfarm.sh':
    ensure => present,
    source => '/tmp/build/etc/profile.d/phpfarm.sh',
    mode => 755,
    require => Exec['Compile PHP (FPM)']
  }

  exec { '/bin/bash -l -c "switch-phpfarm 5.3.28"':
    require => File['/etc/profile.d/phpfarm.sh']
  }
}

node default {
  file { '/run.sh':
    ensure => present,
    source => '/tmp/build/run.sh',
    mode => 755
  }

  include packages
  include php

  Class['packages'] -> Class['php']

  exec { 'apt-get update':
    path => ['/usr/bin'],
    before => Class['packages']
  }
}
