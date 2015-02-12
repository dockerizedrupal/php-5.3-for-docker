class php::phpcs::phpcompatibility {
  require php::phpcs

  file { '/tmp/PHPCompatibility-master.zip':
    ensure => present,
    source => 'puppet:///modules/php/tmp/PHPCompatibility-master.zip'
  }

  bash_exec { 'unzip PHPCompatibility-master.zip':
    cwd => '/tmp',
    require => File['/tmp/PHPCompatibility-master.zip']
  }

  bash_exec { 'mv /tmp/PHPCompatibility-master /root/.composer/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards/PHPCompatibility':
    require => Bash_exec['unzip PHPCompatibility-master.zip']
  }
}
