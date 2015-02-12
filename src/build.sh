#!/usr/bin/env bash

apt-get update

puppet apply --modulepath=/src/build/modules /src/build/build.pp

/src/php.sh clean
