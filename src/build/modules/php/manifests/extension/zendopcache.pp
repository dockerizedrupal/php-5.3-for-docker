class php::extension::zendopcache {
  require php

  file { '/tmp/zendopcache-7.0.3.tgz':
    ensure => present,
    source => 'puppet:///modules/php/tmp/zendopcache-7.0.3.tgz'
  }

  bash_exec { 'cd /tmp && tar xzf zendopcache-7.0.3.tgz':
    require => File['/tmp/zendopcache-7.0.3.tgz']
  }

  bash_exec { 'cd /tmp/zendopcache-7.0.3 && phpize-5.3.29':
    require => Bash_exec['cd /tmp && tar xzf zendopcache-7.0.3.tgz']
  }

  bash_exec { 'cd /tmp/zendopcache-7.0.3 && ./configure --with-php-config=/phpfarm/inst/bin/php-config-5.3.29':
    timeout => 0,
    require => Bash_exec['cd /tmp/zendopcache-7.0.3 && phpize-5.3.29']
  }

  bash_exec { 'cd /tmp/zendopcache-7.0.3 && make':
    timeout => 0,
    require => Bash_exec['cd /tmp/zendopcache-7.0.3 && ./configure --with-php-config=/phpfarm/inst/bin/php-config-5.3.29']
  }

  bash_exec { 'cd /tmp/zendopcache-7.0.3 && make install':
    timeout => 0,
    require => Bash_exec['cd /tmp/zendopcache-7.0.3 && make']
  }
}
