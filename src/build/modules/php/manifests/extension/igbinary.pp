class php::extension::igbinary {
  require php

  file { '/tmp/igbinary-1.2.1.tgz':
    ensure => present,
    source => 'puppet:///modules/php/tmp/igbinary-1.2.1.tgz'
  }

  bash_exec { 'tar xzf igbinary-1.2.1.tgz':
    cwd => '/tmp',
    require => File['/tmp/igbinary-1.2.1.tgz']
  }

  bash_exec { 'phpize-5.3.29 igbinary':
    command => '/phpfarm/inst/bin/phpize-5.3.29',
    cwd => '/tmp/igbinary-1.2.1',
    require => Bash_exec['tar xzf igbinary-1.2.1.tgz']
  }

  bash_exec { 'cd /tmp/igbinary-1.2.1 && ./configure --with-php-config=/phpfarm/inst/bin/php-config-5.3.29 --enable-igbinary':
    timeout => 0,
    require => Bash_exec['phpize-5.3.29 igbinary']
  }

  bash_exec { 'cd /tmp/igbinary-1.2.1 && make':
    timeout => 0,
    require => Bash_exec['cd /tmp/igbinary-1.2.1 && ./configure --with-php-config=/phpfarm/inst/bin/php-config-5.3.29 --enable-igbinary']
  }

  bash_exec { 'cd /tmp/igbinary-1.2.1 && make install':
    timeout => 0,
    require => Bash_exec['cd /tmp/igbinary-1.2.1 && make']
  }
}
