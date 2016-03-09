class build::drush::drush6 {
  require build::user
  require build::php53
  require build::php53::extensions
  require build::composer
  require build::drush::packages

  file { '/tmp/drush-6.7.0.tar.gz':
    ensure => present,
    source => 'puppet:///modules/build/tmp/drush-6.7.0.tar.gz'
  }

  bash_exec { 'cd /tmp && tar xzf drush-6.7.0.tar.gz':
    require => File['/tmp/drush-6.7.0.tar.gz']
  }

  bash_exec { 'mv /tmp/drush-6.7.0 /usr/local/src/drush6':
    require => Bash_exec['cd /tmp && tar xzf drush-6.7.0.tar.gz']
  }

  bash_exec { 'cd /usr/local/src/drush6 && composer install':
    timeout => 0,
    require => Bash_exec['mv /tmp/drush-6.7.0 /usr/local/src/drush6']
  }
}
