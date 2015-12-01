class build::php53::logs {
  bash_exec { 'mkdir -p /var/log/fpm-php': }

  file { '/var/log/fpm-php/error.log':
    ensure => link,
    target => '/dev/stderr',
    force => true,
    require => Bash_exec['mkdir -p /var/log/fpm-php']
  }
}
