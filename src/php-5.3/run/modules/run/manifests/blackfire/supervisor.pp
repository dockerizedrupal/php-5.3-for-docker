class run::blackfire::supervisor {
  file { '/etc/supervisor/conf.d/blackfire.conf':
    ensure => present,
    content => template('run/blackfire.conf.erb'),
    mode => 755
  }
}
