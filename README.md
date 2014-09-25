docker-php-5.3.28
=================

Run the container
-----------------

    CONTAINER=php53 && sudo docker run \
      --name "${CONTAINER}" \
      -h "${CONTAINER}" \
      -p 9000:9000
      -v /var/www:/var/www \
      -d \
      simpledrupalcloud/php:5.3.28

Build the image
---------------

    TMP="$(mktemp -d)" \
      && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/docker-php.git "${TMP}" \
      && cd "${TMP}" \
      && git checkout 5.3.28 \
      && sudo docker build -t simpledrupalcloud/php:5.3.28 . \
      && cd -

Apache directives
-----------------

    <IfModule mod_fastcgi.c>
      AddHandler php .php

      Alias /php53 /var/www/php53
      FastCgiExternalServer /var/www/php53 -host 127.0.0.1:9000 -idle-timeout 300 -pass-header Authorization

      <Location /php53>
        Order deny,allow
        Deny from all
        Allow from env=REDIRECT_STATUS
      </Location>

      Action php /php53
    </IfModule>
