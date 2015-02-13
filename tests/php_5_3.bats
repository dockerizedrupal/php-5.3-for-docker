#!/usr/bin/env bats

FIG_FILE="${BATS_TEST_DIRNAME}/php_5_3.yml"

container() {
  echo "$(fig -f ${FIG_FILE} ps php | grep php | awk '{ print $1 }')"
}

setup() {
  fig -f "${FIG_FILE}" up -d

  sleep 10
}

teardown() {
  fig -f "${FIG_FILE}" kill
  fig -f "${FIG_FILE}" rm --force
}

@test "PHP 5.3" {
  run docker exec "$(container)" /bin/su - root -mc "php -v"

  [ "${status}" -eq 0 ]
  [[ "${output}" == *"PHP 5.3"* ]]
}

@test "PHP 5.3: Extension: xdebug" {
  run docker exec "$(container)" /bin/su - root -mc "php -m | grep 'Xdebug'"

  [ "${status}" -eq 0 ]
}

@test "PHP 5.3: Extension: opcache" {
  run docker exec "$(container)" /bin/su - root -mc "php -m | grep 'Zend OPcache'"

  [ "${status}" -eq 0 ]
}

@test "PHP 5.3: Extension: apd" {
  run docker exec "$(container)" /bin/su - root -mc "php -m | grep 'Advanced PHP Debugger (APD)'"

  [ "${status}" -eq 0 ]
}

@test "PHP 5.3: Extension: redis" {
  run docker exec "$(container)" /bin/su - root -mc "php -m | grep 'redis'"

  [ "${status}" -eq 0 ]
}

@test "PHP 5.3: Extension: redis" {
  run docker exec "$(container)" /bin/su - root -mc "php -m | grep 'redis'"

  [ "${status}" -eq 0 ]
}

@test "PHP 5.3: Extension: redis" {
  run docker exec "$(container)" /bin/su - root -mc "php -m | grep 'redis'"

  [ "${status}" -eq 0 ]
}

@test "PHP 5.3: Extension: igbinary" {
  run docker exec "$(container)" /bin/su - root -mc "php -m | grep 'igbinary'"

  [ "${status}" -eq 0 ]
}

@test "PHP 5.3: Extension: mssql" {
  run docker exec "$(container)" /bin/su - root -mc "php -m | grep 'mssql'"

  [ "${status}" -eq 0 ]
}
