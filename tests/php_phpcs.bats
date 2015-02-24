#!/usr/bin/env bats

FIG_FILE="${BATS_TEST_DIRNAME}/php_phpcs.yml"

container() {
  echo "$(fig -f ${FIG_FILE} ps php | grep php | awk '{ print $1 }')"
}

setup() {
  fig -f "${FIG_FILE}" up -d --allow-insecure-ssl

  sleep 10
}

teardown() {
  fig -f "${FIG_FILE}" kill
  fig -f "${FIG_FILE}" rm --force
}

@test "phpcs" {
  run docker exec "$(container)" /bin/su - root -mc "phpcs --version"

  [ "${status}" -eq 0 ]
  [[ "${output}" == *"1.5.6"* ]]
}

@test "phpcs: phpcompatibility" {
  run docker exec "$(container)" /bin/su - root -mc "phpcs -i | grep PHPCompatibility"

  [ "${status}" -eq 0 ]
}

@test "phpcs: drupal" {
  run docker exec "$(container)" /bin/su - root -mc "phpcs -i | grep Drupal"

  [ "${status}" -eq 0 ]
}
