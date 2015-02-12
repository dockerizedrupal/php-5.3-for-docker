class php {
  require php::packages
  require php::phpfarm
  require php::supervisor
  require php::freetds

  exec { 'mkdir -p /phpfarm/inst/php-5.3.29/etc/conf.d':
    path => ['/bin']
  }

  exec { 'mkdir -p /phpfarm/inst/php-5.3.29/lib/php/extensions/no-debug-non-zts-20090626':
    path => ['/bin']
  }

  file { '/tmp/php-5.3.29.tar.gz':
    ensure => present,
    source => 'puppet:///modules/php/tmp/php-5.3.29.tar.gz'
  }

  exec { 'tar xzf php-5.3.29.tar.gz':
    cwd => '/tmp',
    path => ['/bin'],
    require => File['/tmp/php-5.3.29.tar.gz']
  }

  exec { 'cp -r php-5.3.29 /phpfarm/src/php-5.3.29':
    cwd => '/tmp',
    path => ['/bin'],
    require => Exec['tar xzf php-5.3.29.tar.gz']
  }

  file { '/phpfarm/src/custom/options-5.3.29.sh':
    ensure => present,
    source => 'puppet:///modules/php/phpfarm/src/custom/options-5.3.29.sh',
    mode => 755,
    require => Exec['cp -r php-5.3.29 /phpfarm/src/php-5.3.29']
  }

  exec { '/phpfarm/src/main.sh 5.3.29':
    timeout => 0,
    require => File['/phpfarm/src/custom/options-5.3.29.sh']
  }

  exec { 'rm -r /phpfarm/src/php-5.3.29':
    path => ['/bin'],
    require => Exec['/phpfarm/src/main.sh 5.3.29']
  }

  exec { '/bin/bash -c "CP=1 && cp -r php-5.3.29 /phpfarm/src/php-5.3.29"':
    cwd => '/tmp',
    require => Exec['rm -r /phpfarm/src/php-5.3.29']
  }

  exec { 'cp /src/build/modules/php/files/phpfarm/src/custom/options-5.3.29-fpm.sh /phpfarm/src/custom/options-5.3.29.sh':
    cwd => '/tmp',
    path => ['/bin'],
    require => Exec['/bin/bash -c "CP=1 && cp -r php-5.3.29 /phpfarm/src/php-5.3.29"']
  }

  exec { '/bin/bash -c "PHPFPM=1 && /phpfarm/src/main.sh 5.3.29"':
    timeout => 0,
    require => Exec['cp /src/build/modules/php/files/phpfarm/src/custom/options-5.3.29-fpm.sh /phpfarm/src/custom/options-5.3.29.sh']
  }

  exec { 'rm -rf /phpfarm/src/php-5.3.29':
    path => ['/bin'],
    require => Exec['/bin/bash -c "PHPFPM=1 && /phpfarm/src/main.sh 5.3.29"']
  }

  file { '/phpfarm/inst/php-5.3.29/etc/php-fpm.conf':
    ensure => present,
    source => 'puppet:///modules/php/phpfarm/inst/php-5.3.29/etc/php-fpm.conf',
    mode => 644,
    require => Exec['/bin/bash -c "PHPFPM=1 && /phpfarm/src/main.sh 5.3.29"']
  }

  exec { 'switch-phpfarm 5.3.29':
    provider => shell,
    require => Exec['/bin/bash -c "PHPFPM=1 && /phpfarm/src/main.sh 5.3.29"']
  }
}
