class php::coder {
  if $drupal_version == '6' {
    file { '/root/.drush/coder':
      ensure => link,
      target => '/usr/local/src/coder6'
    }
  }

  if $drupal_version == '7' {
    file { '/root/.drush/coder':
      ensure => link,
      target => '/usr/local/src/coder7'
    }

    file { '/usr/local/src/PHP_CodeSniffer/CodeSniffer/Standards/Drupal':
      ensure => link,
      target => '/usr/local/src/coder7/coder_sniffer/Drupal'
    }
  }
}
