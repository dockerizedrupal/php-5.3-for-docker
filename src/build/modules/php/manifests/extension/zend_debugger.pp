class php::extension::zend_debugger {
  require php

  exec { 'mkdir -p /phpfarm/inst/php-5.3.29/lib/php/extensions/no-debug-non-zts-20090626':
    path => ['/bin']
  }

  file { '/phpfarm/inst/php-5.3.29/lib/php/extensions/no-debug-non-zts-20090626/ZendDebugger.so':
    ensure => present,
    source => 'puppet:///modules/php/tmp/ZendDebugger.so',
    require => Exec['mkdir -p /phpfarm/inst/php-5.3.29/lib/php/extensions/no-debug-non-zts-20090626']
  }
}
