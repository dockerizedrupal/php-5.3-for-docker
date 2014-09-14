docker-php-5.3.28
=================

Run the container
-----------------

    CONTAINER=php5328 && sudo docker run \
      --name "${CONTAINER}" \
      -h "${CONTAINER}" \
      -p 5328:5328
      -v /var/www:/var/www \
      -d \
      simpledrupalcloud/php:5.3.28

Build the image
---------------

    TMP=$(mktemp -d) \
      && git clone http://git.simpledrupalcloud.com/simpledrupalcloud/docker-php.git "${TMP}" \
      && cd "${TMP}" \
      && git checkout 5.3.28 \
      && sudo docker build -t simpledrupalcloud/php:5.3.28 . \
      && cd -