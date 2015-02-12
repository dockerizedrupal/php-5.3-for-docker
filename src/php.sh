#!/usr/bin/env bash

case "${1}" in
  build)
    /bin/bash -c /src/build.sh
    ;;
  clean)
    /bin/bash -c /src/clean.sh
    ;;
  run)
    /bin/bash -c /src/run.sh
    ;;
esac
