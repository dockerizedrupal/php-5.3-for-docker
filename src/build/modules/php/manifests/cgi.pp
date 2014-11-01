class php::cgi {
  require php::packages
  require php::phpfarm

  file { '/phpfarm/src/php-5.3.29.tar.gz':
    ensure => present,
    source => 'puppet:///modules/php/phpfarm/src/php-5.3.29.tar.gz'
  }

  exec { 'tar xzf php-5.3.29.tar.gz':
    cwd => '/phpfarm/src',
    path => ['/bin'],
    require => File['/phpfarm/src/php-5.3.29.tar.gz']
  }

  file { '/phpfarm/src/custom/options-5.3.29.sh':
    ensure => present,
    source => 'puppet:///modules/php/phpfarm/src/custom/options-5.3.29-cgi.sh',
    mode => 755,
    require => Exec['tar xzf php-5.3.29.tar.gz']
  }

  exec { '/phpfarm/src/main.sh 5.3.29':
    timeout => 0,
    require => File['/phpfarm/src/custom/options-5.3.29.sh']
  }

  exec { 'rm -rf /phpfarm/src/php-5.3.29':
    path => ['/bin'],
    require => Exec['/phpfarm/src/main.sh 5.3.29']
  }
}
