class build::drush {
  require build::user
  require build::php
  require build::php::extensions
  require build::composer
  require build::drush::packages

  bash_exec { "su - container -c 'mkdir /home/container/.drush'": }

  file { '/tmp/drush-6.6.0.tar.gz':
    ensure => present,
    source => 'puppet:///modules/build/tmp/drush-6.6.0.tar.gz'
  }

  bash_exec { 'cd /tmp && tar xzf drush-6.6.0.tar.gz':
    require => File['/tmp/drush-6.6.0.tar.gz']
  }

  bash_exec { 'mv /tmp/drush-6.6.0 /usr/local/src/drush6':
    require => Bash_exec['cd /tmp && tar xzf drush-6.6.0.tar.gz']
  }

  bash_exec { 'cd /usr/local/src/drush6 && composer install':
    timeout => 0,
    require => Bash_exec['mv /tmp/drush-6.6.0 /usr/local/src/drush6']
  }

  file { '/tmp/drush-7.0.0.tar.gz':
    ensure => present,
    source => 'puppet:///modules/build/tmp/drush-7.0.0.tar.gz'
  }

  bash_exec { 'cd /tmp && tar xzf drush-7.0.0.tar.gz':
    require => File['/tmp/drush-7.0.0.tar.gz']
  }

  bash_exec { 'mv /tmp/drush-7.0.0 /usr/local/src/drush7':
    require => Bash_exec['cd /tmp && tar xzf drush-7.0.0.tar.gz']
  }

  bash_exec { 'cd /usr/local/src/drush7 && composer install':
    timeout => 0,
    require => Bash_exec['mv /tmp/drush-7.0.0 /usr/local/src/drush7']
  }
}
