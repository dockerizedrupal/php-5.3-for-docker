class build::php53::extensions {
  require build::php53

  include build::php53::extensions::xdebug
  include build::php53::extensions::memcached
  include build::php53::extensions::redis
  include build::php53::extensions::blackfire
  include build::php53::extensions::apcu
  include build::php53::extensions::zendopcache
  include build::php53::extensions::apd
}
