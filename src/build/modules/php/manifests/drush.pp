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

  bash_exec { 'tar xzf drush-6.5.0.tar.gz':
    cwd => '/tmp',
    require => File['/tmp/drush-6.5.0.tar.gz']
  }

  bash_exec { 'mv drush-6.5.0 /opt/drush6':
    cwd => '/tmp',
    require => Bash_exec['tar xzf drush-6.5.0.tar.gz']
  }

  bash_exec { 'cd /opt/drush6 && composer install':
    timeout => 0,
    require => Bash_exec['mv drush-6.5.0 /opt/drush6']
  }

  file { '/tmp/drush-7.0.0-alpha8.tar.gz':
    ensure => present,
    source => 'puppet:///modules/php/tmp/drush-7.0.0-alpha8.tar.gz'
  }

  bash_exec { 'tar xzf drush-7.0.0-alpha8.tar.gz':
    cwd => '/tmp',
    require => File['/tmp/drush-7.0.0-alpha8.tar.gz']
  }

  bash_exec { 'mv drush-7.0.0-alpha8 /opt/drush7':
    cwd => '/tmp',
    require => Bash_exec['tar xzf drush-7.0.0-alpha8.tar.gz']
  }

  bash_exec { 'cd /opt/drush7 && composer install':
    timeout => 0,
    require => Bash_exec['mv drush-7.0.0-alpha8 /opt/drush7']
  }
}
