#!/usr/bin/env bats

DOCKER_COMPOSE_FILE="${BATS_TEST_DIRNAME}/php-5.3_fpm_pm_min_spare_servers.yml"

container() {
  echo "$(docker-compose -f ${DOCKER_COMPOSE_FILE} ps php-5.3 | grep php-5.3 | awk '{ print $1 }')"
}

setup() {
  docker-compose -f "${DOCKER_COMPOSE_FILE}" up -d

  sleep 10
}

teardown() {
  docker-compose -f "${DOCKER_COMPOSE_FILE}" kill
  docker-compose -f "${DOCKER_COMPOSE_FILE}" rm --force
}

@test "php-5.3: fpm: pm.min_spare_servers" {
  run docker exec "$(container)" /bin/su - root -lc "cat /usr/local/src/phpfarm/inst/current/etc/pool.d/www.conf | grep 'pm.min_spare_servers'"

  [ "${status}" -eq 0 ]
  [[ "${output}" == *"2"* ]]
}
