#!/usr/bin/env bats

DOCKER_COMPOSE_FILE="${BATS_TEST_DIRNAME}/php_drupal_8.yml"

container() {
  echo "$(docker-compose -f ${DOCKER_COMPOSE_FILE} ps php | grep php | awk '{ print $1 }')"
}

setup_drupal() {
  docker exec "$(container)" /bin/su - root -mc "wget http://ftp.drupal.org/files/projects/drupal-8.0.0-beta6.tar.gz -O /tmp/drupal-8.0.0-beta6.tar.gz"
  docker exec "$(container)" /bin/su - root -mc "tar xzf /tmp/drupal-8.0.0-beta6.tar.gz -C /tmp"
  docker exec "$(container)" /bin/su - root -mc "rsync -avz /tmp/drupal-8.0.0-beta6/ /httpd/data"
  docker exec "$(container)" /bin/su - root -mc "cp /httpd/data/sites/default/default.services.yml /httpd/data/sites/default/services.yml"
  docker exec "$(container)" /bin/su - root -mc "chown www-data.www-data /httpd/data"
  docker exec "$(container)" /bin/su - root -mc "drush -r /httpd/data -y site-install --db-url=mysqli://root:root@localhost/drupal --account-name=admin --account-pass=admin"
}

setup() {
  docker-compose -f "${DOCKER_COMPOSE_FILE}" up -d --allow-insecure-ssl

  sleep 10

  setup_drupal
}

teardown() {
  docker-compose -f "${DOCKER_COMPOSE_FILE}" kill
  docker-compose -f "${DOCKER_COMPOSE_FILE}" rm --force
}

@test "php: drupal 8" {
  run docker exec "$(container)" /bin/su - root -mc "drush -r /httpd/data/ status | grep 'Drupal bootstrap'"

  [ "${status}" -eq 0 ]
  [[ "${output}" == *"Successful"* ]]
}

@test "php: drupal 8: drush 7" {
  run docker exec "$(container)" /bin/su - root -mc "drush --version"

  [ "${status}" -eq 0 ]
  [[ "${output}" == *"7.0-dev"* ]]
}

@test "php: drupal 8: phpcs" {
  run docker exec "$(container)" /bin/su - root -mc "phpcs --version"

  [ "${status}" -eq 0 ]
  [[ "${output}" == *"2.3.0"* ]]
}

@test "php: drupal 8: phpcs: phpcompatibility" {
  run docker exec "$(container)" /bin/su - root -mc "phpcs -i | grep 'PHPCompatibility'"

  [ "${status}" -eq 0 ]
}

@test "php: drupal 8: phpcs: drupal" {
  run docker exec "$(container)" /bin/su - root -mc "phpcs -i | grep 'Drupal'"

  [ "${status}" -eq 0 ]
}
