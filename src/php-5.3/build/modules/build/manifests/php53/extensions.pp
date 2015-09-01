class build::php53::extensions {
  require build::php53

  include build::php53::extension::xdebug
  include build::php53::extension::memcached
  include build::php53::extension::redis
  include build::php53::extension::blackfire
  include build::php53::extension::apcu
  include build::php53::extension::zendopcache
  include build::php53::extension::apd
}
