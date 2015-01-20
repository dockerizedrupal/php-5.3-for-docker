class php::drush {
  require php
  require php::extensions
  require php::composer
  require php::drush::packages

  exec { '/bin/su - root -c "composer global require drush/drush:6.*"':
    timeout => 0
  }

  file { '/etc/bash_completion.d/drush.complete.sh':
    ensure => present,
    source => 'puppet:///modules/php/etc/bash_completion.d/drush.complete.sh',
    mode => 755
  }
}
