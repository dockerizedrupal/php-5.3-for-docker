class php::extension::xdebug {
  require php

  file { '/tmp/xdebug-2.2.6.tgz':
    ensure => present,
    source => 'puppet:///modules/php/tmp/xdebug-2.2.6.tgz'
  }

  bash_exec { 'tar xzf xdebug-2.2.6.tgz':
    cwd => '/tmp',
    require => File['/tmp/xdebug-2.2.6.tgz']
  }

  bash_exec { 'phpize-5.3.29 xdebug':
    command => '/phpfarm/inst/bin/phpize-5.3.29',
    cwd => '/tmp/xdebug-2.2.6',
    require => Bash_exec['tar xzf xdebug-2.2.6.tgz']
  }

  bash_exec { 'cd /tmp/xdebug-2.2.6 && ./configure --with-php-config=/phpfarm/inst/bin/php-config-5.3.29':
    timeout => 0,
    require => Bash_exec['phpize-5.3.29 xdebug']
  }

  bash_exec { 'cd /tmp/xdebug-2.2.6 && make':
    timeout => 0,
    require => Bash_exec['cd /tmp/xdebug-2.2.6 && ./configure --with-php-config=/phpfarm/inst/bin/php-config-5.3.29']
  }

  bash_exec { 'cd /tmp/xdebug-2.2.6 && make install':
    timeout => 0,
    require => Bash_exec['cd /tmp/xdebug-2.2.6 && make']
  }
}
