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

  echo "${output}"

  [ "${status}" -eq 0 ]
  [[ "${output}" == *"PHP 5.3"* ]]
}

@test "PHP 5.3: Extension: xdebug" {
  run docker exec "$(container)" /bin/su - root -mc "php -m | grep 'Xdebug'"

  echo "${output}"

  [ "${status}" -eq 0 ]
}

@test "PHP 5.3: Extension: opcache" {
  run docker exec "$(container)" /bin/su - root -mc "php -m | grep 'Zend OPcache'"

  echo "${output}"

  [ "${status}" -eq 0 ]
}

@test "PHP 5.3: Extension: apd" {
  run docker exec "$(container)" /bin/su - root -mc "php -m | grep 'Advanced PHP Debugger (APD)'"

  echo "${output}"

  [ "${status}" -eq 0 ]
}

@test "PHP 5.3: Extension: redis" {
  run docker exec "$(container)" /bin/su - root -mc "php -m | grep 'redis'"

  echo "${output}"

  [ "${status}" -eq 0 ]
}

@test "PHP 5.3: Extension: redis" {
  run docker exec "$(container)" /bin/su - root -mc "php -m | grep 'redis'"

  echo "${output}"

  [ "${status}" -eq 0 ]
}

@test "PHP 5.3: Extension: redis" {
  run docker exec "$(container)" /bin/su - root -mc "php -m | grep 'redis'"

  echo "${output}"

  [ "${status}" -eq 0 ]
}

@test "PHP 5.3: Extension: igbinary" {
  run docker exec "$(container)" /bin/su - root -mc "php -m | grep 'igbinary'"

  echo "${output}"

  [ "${status}" -eq 0 ]
}

@test "PHP 5.3: Extension: mssql" {
  run docker exec "$(container)" /bin/su - root -mc "php -m | grep 'mssql'"

  echo "${output}"

  [ "${status}" -eq 0 ]
}
