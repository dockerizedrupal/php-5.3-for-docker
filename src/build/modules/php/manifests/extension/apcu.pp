class php::extension::apcu {
  require php

  file { '/tmp/apcu-4.0.7.tgz':
    ensure => present,
    source => 'puppet:///modules/php/tmp/apcu-4.0.7.tgz'
  }

  bash_exec { 'tar xzf apcu-4.0.7.tgz':
    cwd => '/tmp',
    require => File['/tmp/apcu-4.0.7.tgz']
  }

  bash_exec { 'phpize-5.3.29 apcu':
    command => '/phpfarm/inst/bin/phpize-5.3.29',
    cwd => '/tmp/apcu-4.0.7',
    require => Bash_exec['tar xzf apcu-4.0.7.tgz']
  }

  bash_exec { 'cd /tmp/apcu-4.0.7 && ./configure --with-php-config=/phpfarm/inst/bin/php-config-5.3.29':
    timeout => 0,
    require => Bash_exec['phpize-5.3.29 apcu']
  }

  bash_exec { 'cd /tmp/apcu-4.0.7 && make':
    timeout => 0,
    require => Bash_exec['cd /tmp/apcu-4.0.7 && ./configure --with-php-config=/phpfarm/inst/bin/php-config-5.3.29']
  }

  bash_exec { 'cd /tmp/apcu-4.0.7 && make install':
    timeout => 0,
    require => Bash_exec['cd /tmp/apcu-4.0.7 && make']
  }
}
