class php::extension::memcached {
  require php
  require php::extension::igbinary

  file { '/tmp/libmemcached-1.0.18.tar.gz':
    ensure => present,
    source => 'puppet:///modules/php/tmp/libmemcached-1.0.18.tar.gz'
  }

  bash_exec { 'tar xzf libmemcached-1.0.18.tar.gz':
    cwd => '/tmp',
    require => File['/tmp/libmemcached-1.0.18.tar.gz']
  }

  bash_exec { 'cd /tmp/libmemcached-1.0.18 && ./configure':
    timeout => 0,
    require => Bash_exec['tar xzf libmemcached-1.0.18.tar.gz']
  }

  bash_exec { 'cd /tmp/libmemcached-1.0.18 && make':
    timeout => 0,
    require => Bash_exec['cd /tmp/libmemcached-1.0.18 && ./configure']
  }

  bash_exec { 'cd /tmp/libmemcached-1.0.18 && make install':
    timeout => 0,
    require => Bash_exec['cd /tmp/libmemcached-1.0.18 && make']
  }

  file { '/tmp/memcached-2.2.0.tgz':
    ensure => present,
    source => 'puppet:///modules/php/tmp/memcached-2.2.0.tgz',
    require => Bash_exec['cd /tmp/libmemcached-1.0.18 && make install']
  }

  bash_exec { 'tar xzf memcached-2.2.0.tgz':
    cwd => '/tmp',
    require => File['/tmp/memcached-2.2.0.tgz']
  }

  bash_exec { 'phpize-5.3.29 memcached':
    command => '/phpfarm/inst/bin/phpize-5.3.29',
    cwd => '/tmp/memcached-2.2.0',
    require => Bash_exec['tar xzf memcached-2.2.0.tgz']
  }

  bash_exec { 'cd /tmp/memcached-2.2.0 && ./configure --with-php-config=/phpfarm/inst/bin/php-config-5.3.29 --enable-memcached-igbinary':
    timeout => 0,
    require => Bash_exec['phpize-5.3.29 memcached']
  }

  bash_exec { 'cd /tmp/memcached-2.2.0 && make':
    timeout => 0,
    require => Bash_exec['cd /tmp/memcached-2.2.0 && ./configure --with-php-config=/phpfarm/inst/bin/php-config-5.3.29 --enable-memcached-igbinary']
  }

  bash_exec { 'cd /tmp/memcached-2.2.0 && make install':
    timeout => 0,
    require => Bash_exec['cd /tmp/memcached-2.2.0 && make']
  }
}
