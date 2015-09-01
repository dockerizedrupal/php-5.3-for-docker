class build::php53::supervisor {
  file { '/etc/supervisor/conf.d/php-5.3.conf':
    ensure => present,
    source => 'puppet:///modules/build/etc/supervisor/conf.d/php-5.3.conf',
    mode => 644
  }
}
