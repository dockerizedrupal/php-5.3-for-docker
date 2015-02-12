class php::composer::packages {
  require php

  exec { '/bin/bash -c "curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename composer"':
    timeout => 0
  }
}
