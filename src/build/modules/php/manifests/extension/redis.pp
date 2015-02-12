class php::extension::redis {
  require php
  require php::extension::igbinary

  file { '/tmp/redis-2.2.5.tgz':
    ensure => present,
    source => 'puppet:///modules/php/tmp/redis-2.2.5.tgz'
  }

  bash_exec { 'tar xzf redis-2.2.5.tgz':
    cwd => '/tmp',
    require => File['/tmp/redis-2.2.5.tgz']
  }

  bash_exec { 'phpize-5.3.29 redis':
    command => '/phpfarm/inst/bin/phpize-5.3.29',
    cwd => '/tmp/redis-2.2.5',
    require => Bash_exec['tar xzf redis-2.2.5.tgz']
  }

  bash_exec { 'cd /tmp/redis-2.2.5 && ./configure --with-php-config=/phpfarm/inst/bin/php-config-5.3.29 --enable-redis-igbinary':
    timeout => 0,
    require => Bash_exec['phpize-5.3.29 redis']
  }

  bash_exec { 'cd /tmp/redis-2.2.5 && make':
    timeout => 0,
    require => Bash_exec['cd /tmp/redis-2.2.5 && ./configure --with-php-config=/phpfarm/inst/bin/php-config-5.3.29 --enable-redis-igbinary']
  }

  bash_exec { 'cd /tmp/redis-2.2.5 && make install':
    timeout => 0,
    require => Bash_exec['cd /tmp/redis-2.2.5 && make']
  }
}
