class build::cron {
  file { '/var/log/cron.log':
    ensure => link,
    target => '/dev/stdout',
    force => true
  }
}
