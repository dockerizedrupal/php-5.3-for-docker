class php::phpcs {
  require php
  require php::composer

  bash_exec { 'composer global require squizlabs/PHP_CodeSniffer:\<2':
    timeout => 0
  }
}
