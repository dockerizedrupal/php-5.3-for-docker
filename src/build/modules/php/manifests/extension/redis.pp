class php::extension::redis {
  require php
  require php::extension::igbinary

  file { '/tmp/redis-2.2.5.tgz':
    ensure => present,
    source => 'puppet:///modules/php/tmp/redis-2.2.5.tgz'
  }

  exec { 'tar xzf redis-2.2.5.tgz':
    cwd => '/tmp',
    path => ['/bin'],
    require => File['/tmp/redis-2.2.5.tgz']
  }

  exec { 'phpize-5.3.29 redis':
    command => '/phpfarm/inst/bin/phpize-5.3.29',
    cwd => '/tmp/redis-2.2.5',
    require => Exec['tar xzf redis-2.2.5.tgz']
  }

  exec { '/bin/bash -c "cd /tmp/redis-2.2.5 && ./configure --with-php-config=/phpfarm/inst/bin/php-config-5.3.29 --enable-redis-igbinary"':
    timeout => 0,
    require => Exec['phpize-5.3.29 redis']
  }

  exec { '/bin/bash -c "cd /tmp/redis-2.2.5 && make"':
    timeout => 0,
    require => Exec['/bin/bash -c "cd /tmp/redis-2.2.5 && ./configure --with-php-config=/phpfarm/inst/bin/php-config-5.3.29 --enable-redis-igbinary"']
  }

  exec { '/bin/bash -c "cd /tmp/redis-2.2.5 && make install"':
    timeout => 0,
    require => Exec['/bin/bash -c "cd /tmp/redis-2.2.5 && make"']
  }
}
