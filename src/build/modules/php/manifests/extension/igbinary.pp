class php::extension::igbinary {
  require php

  file { '/tmp/igbinary-1.2.1.tgz':
    ensure => present,
    source => 'puppet:///modules/php/tmp/igbinary-1.2.1.tgz'
  }

  exec { 'tar xzf igbinary-1.2.1.tgz':
    cwd => '/tmp',
    path => ['/bin'],
    require => File['/tmp/igbinary-1.2.1.tgz']
  }

  exec { 'phpize-5.3.29 igbinary':
    command => '/phpfarm/inst/bin/phpize-5.3.29',
    cwd => '/tmp/igbinary-1.2.1',
    require => Exec['tar xzf igbinary-1.2.1.tgz']
  }

  exec { '/bin/su - root -mc "cd /tmp/igbinary-1.2.1 && ./configure --with-php-config=/phpfarm/inst/bin/php-config-5.3.29 --enable-igbinary"':
    timeout => 0,
    require => Exec['phpize-5.3.29 igbinary']
  }

  exec { '/bin/su - root -mc "cd /tmp/igbinary-1.2.1 && make"':
    timeout => 0,
    require => Exec['/bin/su - root -mc "cd /tmp/igbinary-1.2.1 && ./configure --with-php-config=/phpfarm/inst/bin/php-config-5.3.29 --enable-igbinary"']
  }

  exec { '/bin/su - root -mc "cd /tmp/igbinary-1.2.1 && make install"':
    timeout => 0,
    require => Exec['/bin/su - root -mc "cd /tmp/igbinary-1.2.1 && make"']
  }
}
