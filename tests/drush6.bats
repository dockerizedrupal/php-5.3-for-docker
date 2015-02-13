#!/usr/bin/env bats

FIG_FILE="${BATS_TEST_DIRNAME}/drush6.yml"

container() {
  echo "$(fig -f ${FIG_FILE} ps php | grep php | awk '{ print $1 }')"
}

setup_drupal() {
  docker exec -i -t "$(container)" /bin/su - root -mc "wget http://ftp.drupal.org/files/projects/drupal-7.34.tar.gz -O /tmp/drupal-7.34.tar.gz"
  docker exec -i -t "$(container)" /bin/su - root -mc "tar xzf /tmp/drupal-7.34.tar.gz -C /tmp"
  docker exec -i -t "$(container)" /bin/su - root -mc "rsync -avz /tmp/drupal-7.34/ /httpd/data"
  docker exec -i -t "$(container)" /bin/su - root -mc "chown www-data.www-data /httpd/data"
  docker exec -i -t "$(container)" /bin/su - root -mc "drush -r /httpd/data -y site-install --db-url=mysqli://root:root@localhost/drupal --account-name=admin --account-pass=admin"
}

setup() {
  fig -f "${FIG_FILE}" up -d

  sleep 10

  setup_drupal
}

teardown() {
  fig -f "${FIG_FILE}" kill
  fig -f "${FIG_FILE}" rm --force
}

@test "drush --version" {
  run docker exec -i -t "$(container)" /bin/su - root -mc "drush --version"

  echo "${output}"

  [ "${status}" -eq 0 ]
  [[ "${output}" == *"6.5.0"* ]]
}

@test "drush status" {
  run docker exec -i -t "$(container)" /bin/su - root -mc "drush -r /httpd/data/ status"

  echo "${output}"

  [ "${status}" -eq 0 ]
  [[ "$(echo ${output} | grep 'Drupal bootstrap')" == *"Successful"* ]]
}

@test "drush cc all" {
  run docker exec -i -t "$(container)" /bin/su - root -mc "drush -r /httpd/data/ cc all"

  echo "${output}"

  [ "${status}" -eq 0 ]
  [[ "${output}" == *"'all' cache was cleared."* ]]
}
