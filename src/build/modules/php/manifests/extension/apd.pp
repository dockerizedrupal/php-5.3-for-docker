class php::extension::apd {
  require php

  file { '/tmp/apd-1.0.1.tgz':
    ensure => present,
    source => 'puppet:///modules/php/tmp/apd-1.0.1.tgz'
  }

  bash_exec { 'tar xzf apd-1.0.1.tgz':
    cwd => '/tmp',
    require => File['/tmp/apd-1.0.1.tgz']
  }

  file { '/tmp/file.patch':
    ensure => present,
    source => 'puppet:///modules/php/tmp/file.patch',
    require => Bash_exec['tar xzf apd-1.0.1.tgz']
  }

  bash_exec { 'patch < /tmp/file.patch':
    cwd => '/tmp/apd-1.0.1',
    require => File['/tmp/file.patch']
  }

  bash_exec { 'phpize-5.3.29 apd':
    command => '/phpfarm/inst/bin/phpize-5.3.29',
    cwd => '/tmp/apd-1.0.1',
    require => Bash_exec['patch < /tmp/file.patch']
  }

  bash_exec { 'cd /tmp/apd-1.0.1 && ./configure --with-php-config=/phpfarm/inst/bin/php-config-5.3.29':
    timeout => 0,
    require => Bash_exec['phpize-5.3.29 apd']
  }

  bash_exec { 'cd /tmp/apd-1.0.1 && make':
    timeout => 0,
    require => Bash_exec['cd /tmp/apd-1.0.1 && ./configure --with-php-config=/phpfarm/inst/bin/php-config-5.3.29']
  }

  bash_exec { 'cd /tmp/apd-1.0.1 && make install':
    timeout => 0,
    require => Bash_exec['cd /tmp/apd-1.0.1 && make']
  }
}
