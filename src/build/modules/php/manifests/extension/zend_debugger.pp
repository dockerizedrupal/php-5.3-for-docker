class php::extension::zend_debugger {
  require php

  exec { 'mkdir -p /phpfarm/inst/php-5.3.29/lib/php/extensions/ZendDebugger-20110410-linux-glibc23-x86_64/5_3_x_comp':
    path => ['/bin']
  }

  file { '/phpfarm/inst/php-5.3.29/lib/php/extensions/ZendDebugger-20110410-linux-glibc23-x86_64/5_3_x_comp/ZendDebugger.so':
    ensure => present,
    source => 'puppet:///modules/php/phpfarm/inst/php-5.3.29/lib/php/extensions/ZendDebugger-20110410-linux-glibc23-x86_64/5_3_x_comp/ZendDebugger.so',
    require => Exec['mkdir -p /phpfarm/inst/php-5.3.29/lib/php/extensions/ZendDebugger-20110410-linux-glibc23-x86_64/5_3_x_comp']
  }
}
