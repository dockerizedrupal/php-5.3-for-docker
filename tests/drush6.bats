#!/usr/bin/env bats

FIG_FILE="${BATS_TEST_DIRNAME}/drush6.yml"

container() {
  echo "$(fig -f ${FIG_FILE} ps php | grep php | awk '{ print $1 }')"
}

setup_drupal() {
  docker exec -i -t "$(container)" /bin/su - root -mc "wget http://ftp.drupal.org/files/projects/drupal-7.34.tar.gz -O /tmp/drupal-7.34.tar.gz > /dev/null 2>&1"
  docker exec -i -t "$(container)" /bin/su - root -mc "tar xzf /tmp/drupal-7.34.tar.gz -C /tmp > /dev/null 2>&1"
  docker exec -i -t "$(container)" /bin/su - root -mc "rsync -avz /tmp/drupal-7.34/ /httpd/data > /dev/null 2>&1"
  docker exec -i -t "$(container)" /bin/su - root -mc "cd /httpd/data && chown www-data.www-data . > /dev/null 2>&1"
  docker exec -i -t "$(container)" /bin/su - root -mc "drush -r /httpd/data -y site-install --db-url=mysql://root:root@localhost/drupal --account-name=admin --account-pass=admin > /dev/null 2>&1"
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
  [[ "${output}" == *"drush version 6.5.0"* ]]
}

@test "drush cc all" {
  run docker exec -i -t "$(container)" /bin/su - root -mc "drush -r /httpd/data/ cc all"

  echo "${output}"

  [ "${status}" -eq 0 ]
  [[ "${output}" == *"'all' cache was cleared in"* ]]
}
