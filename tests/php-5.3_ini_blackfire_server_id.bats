#!/usr/bin/env bats

DOCKER_COMPOSE_FILE="${BATS_TEST_DIRNAME}/php-5.3_ini_blackfire_server_id.yml"

container() {
  echo "$(docker-compose -f ${DOCKER_COMPOSE_FILE} ps php | grep php | awk '{ print $1 }')"
}

setup() {
  docker-compose -f "${DOCKER_COMPOSE_FILE}" up -d

  sleep 20
}

teardown() {
  docker-compose -f "${DOCKER_COMPOSE_FILE}" kill
  docker-compose -f "${DOCKER_COMPOSE_FILE}" rm --force
}

@test "php-5.3: ini: blackfire.server_id" {
  run docker exec "$(container)" /bin/su - root -mc "cat /usr/local/src/phpfarm/inst/current/etc/conf.d/blackfire.ini | grep 'blackfire.server_id'"

  [ "${status}" -eq 0 ]
  [[ "${output}" == *"d8108598-7a7a-4c5e-8f03-d0bccadc0931"* ]]
}
