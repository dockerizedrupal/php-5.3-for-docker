class php::composer {
  require php
  require php::composer::packages

  file { '/root/.bashrc':
    ensure => present,
    source => 'puppet:///modules/php/root/.bashrc',
    mode => 644
  }
}
