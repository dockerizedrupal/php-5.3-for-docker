class php::blackfire {
  file { '/usr/local/src/phpfarm/inst/current/etc/conf.d/blackfire.ini':
    ensure => present,
    content => template('php/blackfire.ini.erb'),
    mode => 644
  }
}
