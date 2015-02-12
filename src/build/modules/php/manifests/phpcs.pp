class php::phpcs {
  require php
  require php::composer

  exec { 'composer global require squizlabs/PHP_CodeSniffer:\<2':
    timeout => 0,
    path => ['/usr/local/bin']
  }
}
