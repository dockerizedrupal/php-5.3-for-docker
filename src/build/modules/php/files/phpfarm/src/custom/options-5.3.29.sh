configoptions="--with-libdir=/lib/x86_64-linux-gnu \
  --disable-debug \
  --enable-cgi \
  --enable-gd-native-ttf \
  --enable-exif \
  --enable-ftp \
  --enable-bcmath \
  --enable-sockets \
  --enable-soap \
  --enable-calendar \
  --enable-mbstring \
  --enable-zip \
  --with-curl \
  --with-gd \
  --with-jpeg-dir=/usr \
  --with-png-dir=/usr \
  --with-mhash \
  --with-mcrypt \
  --with-mysqli \
  --with-mysql \
  --with-pdo-mysql \
  --with-iconv \
  --with-pear \
  --with-openssl \
  --with-iconv \
  --with-bz2 \
  --with-zlib \
  --with-gettext \
  --with-pspell \
  --with-ldap=/usr \
"

if [ "${PHPFPM}" = 1 ]; then
  configoptions="${configoptions} \
  --enable-fpm \
"
fi
