class php::drush {
  require php
  require php::extensions
  require php::composer
  require php::drush::packages

  bash_exec { 'mkdir /root/.drush': }

  file { '/tmp/drush-6.5.0.tar.gz':
    ensure => present,
    source => 'puppet:///modules/php/tmp/drush-6.5.0.tar.gz'
  }

  bash_exec { 'cd /tmp && tar xzf drush-6.5.0.tar.gz':
    require => File['/tmp/drush-6.5.0.tar.gz']
  }

  bash_exec { 'mv /tmp/drush-6.5.0 /usr/local/src/drush6':
    require => Bash_exec['cd /tmp && tar xzf drush-6.5.0.tar.gz']
  }

  bash_exec { 'cd /usr/local/src/drush6 && composer install':
    timeout => 0,
    require => Bash_exec['mv /tmp/drush-6.5.0 /usr/local/src/drush6']
  }

  file { '/tmp/drush-7.0.0-alpha8.tar.gz':
    ensure => present,
    source => 'puppet:///modules/php/tmp/drush-7.0.0-alpha8.tar.gz'
  }

  bash_exec { 'cd /tmp && tar xzf drush-7.0.0-alpha8.tar.gz':
    require => File['/tmp/drush-7.0.0-alpha8.tar.gz']
  }

  bash_exec { 'mv /tmp/drush-7.0.0-alpha8 /usr/local/src/drush7':
    require => Bash_exec['cd /tmp && tar xzf drush-7.0.0-alpha8.tar.gz']
  }

  bash_exec { 'cd /usr/local/src/drush7 && composer install':
    timeout => 0,
    require => Bash_exec['mv /tmp/drush-7.0.0-alpha8 /usr/local/src/drush7']
  }
}
