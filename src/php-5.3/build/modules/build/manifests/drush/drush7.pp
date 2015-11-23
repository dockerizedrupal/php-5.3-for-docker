class build::drush::drush7 {
  require build::user
  require build::php53
  require build::php53::extensions
  require build::composer
  require build::drush::packages

  file { '/tmp/drush-7.1.0.tar.gz':
    ensure => present,
    source => 'puppet:///modules/build/tmp/drush-7.1.0.tar.gz'
  }

  bash_exec { 'cd /tmp && tar xzf drush-7.1.0.tar.gz':
    require => File['/tmp/drush-7.1.0.tar.gz']
  }

  bash_exec { 'mv /tmp/drush-7.1.0 /usr/local/src/drush7':
    require => Bash_exec['cd /tmp && tar xzf drush-7.1.0.tar.gz']
  }

  bash_exec { 'cd /usr/local/src/drush7 && composer install':
    timeout => 0,
    require => Bash_exec['mv /tmp/drush-7.1.0 /usr/local/src/drush7']
  }
}
