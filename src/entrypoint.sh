#!/usr/bin/env bash

case "${1}" in
  build)
    /bin/su - root -mc "apt-get update && /src/php-5.3/build.sh && /src/php-5.3/clean.sh"
    ;;
  run)
    /bin/su - root -mc "source /src/php-5.3/variables.sh && /src/php-5.3/run.sh"
    ;;
esac
