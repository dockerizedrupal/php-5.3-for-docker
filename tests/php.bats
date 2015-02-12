#!/usr/bin/env bats

CONTAINER="php"

setup() {
  docker run --name "${CONTAINER}" -h "${CONTAINER}" -p 9000:9000 -d simpledrupalcloud/php:5.3-dev

  sleep 5
}

teardown() {
  docker rm -f "${CONTAINER}"
}

@test "php" {
  docker exec "${CONTAINER}" /bin/bash -c "php -v"
}

@test "php: xdebug" {
  docker exec "${CONTAINER}" /bin/bash -c "php -m | grep 'Xdebug'"
}

@test "php: zend opcache" {
  docker exec "${CONTAINER}" /bin/bash -c "php -m | grep 'Zend OPcache'"
}

@test "php: advanced php debugger (apd)" {
  docker exec "${CONTAINER}" /bin/bash -c "php -m | grep 'Advanced PHP Debugger (APD)'"
}

@test "php: apcu" {
  docker exec "${CONTAINER}" /bin/bash -c "php -m | grep 'apcu'"
}

@test "php: memcached" {
  docker exec "${CONTAINER}" /bin/bash -c "php -m | grep 'memcached'"
}

@test "php: redis" {
  docker exec "${CONTAINER}" /bin/bash -c "php -m | grep 'redis'"
}

@test "php: igbinary" {
  docker exec "${CONTAINER}" /bin/bash -c "php -m | grep 'igbinary'"
}

@test "php: mssql" {
  docker exec "${CONTAINER}" /bin/bash -c "php -m | grep 'mssql'"
}

@test "drush" {
  docker exec "${CONTAINER}" /bin/bash -c "drush status"
}
