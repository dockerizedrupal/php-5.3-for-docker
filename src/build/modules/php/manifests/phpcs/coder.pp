class php::phpcs::coder {
  require php::phpcs
  require php::drush

  file { '/tmp/coder-7.x-2.4.tar.gz':
    ensure => present,
    source => 'puppet:///modules/php/tmp/coder-7.x-2.4.tar.gz'
  }

  bash_exec { 'tar xzf coder-7.x-2.4.tar.gz':
    cwd => '/tmp',
    require => File['/tmp/coder-7.x-2.4.tar.gz']
  }

  bash_exec { 'mv /tmp/coder /root/.drush/coder':
    require => Bash_exec['tar xzf coder-7.x-2.4.tar.gz']
  }

  file { '/root/.composer/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards/Drupal':
    ensure => link,
    target => '/root/.drush/coder/coder_sniffer/Drupal',
    require => Bash_exec['mv /tmp/coder /root/.drush/coder']
  }
}
