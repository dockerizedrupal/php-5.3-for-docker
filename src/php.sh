#!/usr/bin/env bash

case "${1}" in
  build)
    /bin/su - root -mc /src/build.sh
    ;;
  clean)
    /bin/su - root -mc /src/clean.sh
    ;;
  run)
    /bin/su - root -mc /src/run.sh
    ;;
esac
