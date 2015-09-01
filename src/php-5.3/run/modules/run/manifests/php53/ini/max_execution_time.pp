class run::php53::ini::max_execution_time {
  file { '/usr/local/src/phpfarm/inst/current/etc/conf.d/max_execution_time.ini':
    ensure => present,
    content => template('run/php53/ini/max_execution_time.ini.erb'),
    mode => 644
  }
}
