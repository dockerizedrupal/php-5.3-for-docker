class build::php53::extensions::igbinary {
  require build::php53

  file { '/tmp/igbinary-1.2.1.tgz':
    ensure => present,
    source => 'puppet:///modules/build/tmp/igbinary-1.2.1.tgz'
  }

  bash_exec { 'cd /tmp && tar xzf igbinary-1.2.1.tgz':
    require => File['/tmp/igbinary-1.2.1.tgz']
  }

  bash_exec { 'cd /tmp/igbinary-1.2.1 && phpize-5.3.29':
    require => Bash_exec['cd /tmp && tar xzf igbinary-1.2.1.tgz']
  }

  bash_exec { 'cd /tmp/igbinary-1.2.1 && ./configure --with-php-config=/usr/local/src/phpfarm/inst/bin/php-config-5.3.29 --enable-igbinary':
    timeout => 0,
    require => Bash_exec['cd /tmp/igbinary-1.2.1 && phpize-5.3.29']
  }

  bash_exec { 'cd /tmp/igbinary-1.2.1 && make':
    timeout => 0,
    require => Bash_exec['cd /tmp/igbinary-1.2.1 && ./configure --with-php-config=/usr/local/src/phpfarm/inst/bin/php-config-5.3.29 --enable-igbinary']
  }

  bash_exec { 'cd /tmp/igbinary-1.2.1 && make install':
    timeout => 0,
    require => Bash_exec['cd /tmp/igbinary-1.2.1 && make']
  }

  file { '/usr/local/src/phpfarm/inst/current/etc/conf.d/igbinary.ini':
    ensure => present,
    source => 'puppet:///modules/build/usr/local/src/phpfarm/inst/current/etc/conf.d/igbinary.ini',
    mode => 644,
    require => Bash_exec['cd /tmp/igbinary-1.2.1 && make install']
  }
}
