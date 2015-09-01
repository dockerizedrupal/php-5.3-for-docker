class build::php53::extension::zend_debugger {
  require build::php53

  file { '/usr/local/src/phpfarm/inst/current/lib/php/extensions/no-debug-non-zts-20090626/ZendDebugger.so':
    ensure => present,
    source => 'puppet:///modules/build/tmp/ZendDebugger.so'
  }
}
