docker-php-5.3.28
=================

Run the container
-----------------

    sudo docker run \
      --name php5328 \
      --net host \
      --volumes-from apache \
      -d \
      simpledrupalcloud/php:5.3.28

Build the image yourself
------------------------

    git clone http://git.simpledrupalcloud.com/simpledrupalcloud/docker-php.git docker-php
    cd docker-php
    git checkout 5.3.28
    sudo docker build -t php:5.3.28 .