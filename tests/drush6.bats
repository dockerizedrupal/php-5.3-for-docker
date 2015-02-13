#!/usr/bin/env bats

FIG_FILE="${BATS_TEST_DIRNAME}/drush6.yml"

container() {
  echo "$(fig -f ${FIG_FILE} ps php | grep php | awk '{ print $1 }')"
}

setup_drupal() {
  command() {
    cat <<EOF
wget http://ftp.drupal.org/files/projects/drupal-7.34.tar.gz -O /tmp/drupal-7.34.tar.gz
  && tar xzf /tmp/drupal-7.34.tar.gz -C /tmp
  && rsync -avz /tmp/drupal-7.34/ /httpd/data
  && cd /httpd/data && chown www-data.www-data .
  && drush -r /httpd/data -y site-install --db-url=mysqli://root:root@localhost/drupal --account-name=admin --account-pass=admin
EOF
  }

  docker exec -i -t "$(container)" /bin/su - root -mc "$(command > /dev/null 2>&1)" > /dev/null 2>&1
}

setup() {
  fig -f "${FIG_FILE}" up -d > /dev/null 2>&1

  sleep 10

  setup_drupal
}

teardown() {
  fig -f "${FIG_FILE}" kill > /dev/null 2>&1
  fig -f "${FIG_FILE}" rm --force > /dev/null 2>&1
}

@test "drush --version" {
  run docker exec -i -t "$(container)" /bin/su - root -mc "drush --version"

  echo "${output}"

  [ "${status}" -eq 0 ]
  [[ "${output}" == *"6.5.0"* ]]
}

@test "drush cc all" {
  run docker exec -i -t "$(container)" /bin/su - root -mc "drush -r /httpd/data/ cc all"

  echo "${output}"

  [ "${status}" -eq 0 ]
  [[ "${output}" == *"'all' cache was cleared."* ]]
}
