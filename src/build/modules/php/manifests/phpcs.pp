class php::phpcs {
  require php
  require php::composer

  exec { '/bin/su - root -c "composer global require squizlabs/PHP_CodeSniffer:\<2"':
    timeout => 0
  }
}
