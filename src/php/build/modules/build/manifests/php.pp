class build::php {
  require build::php::packages
  require build::php::supervisor
  require build::phpfarm
  require build::freetds

  bash_exec { 'mkdir -p /usr/local/src/phpfarm/inst/php-5.3.29/etc/conf.d': }

  bash_exec { 'mkdir -p /usr/local/src/phpfarm/inst/php-5.3.29/etc/fpm.d': }

  bash_exec { 'mkdir -p /usr/local/src/phpfarm/inst/php-5.3.29/etc/pool.d': }

  file { '/usr/local/src/phpfarm/inst/php-5.3.29/etc/pool.d/www.conf':
    ensure => present,
    source => 'puppet:///modules/build/usr/local/src/phpfarm/inst/php-5.3.29/etc/pool.d/www.conf',
    mode => 644,
    require => Bash_exec['mkdir -p /usr/local/src/phpfarm/inst/php-5.3.29/etc/pool.d']
  }
  
  bash_exec { 'mkdir -p /usr/local/src/phpfarm/inst/php-5.3.29/lib/php/extensions/no-debug-non-zts-20090626': }

  file { '/tmp/php-5.3.29.tar.gz':
    ensure => present,
    source => 'puppet:///modules/build/tmp/php-5.3.29.tar.gz'
  }

  bash_exec { 'cd /tmp && tar xzf php-5.3.29.tar.gz':
    require => File['/tmp/php-5.3.29.tar.gz']
  }

  bash_exec { 'cp -r /tmp/php-5.3.29 /usr/local/src/phpfarm/src/php-5.3.29':
    require => Bash_exec['cd /tmp && tar xzf php-5.3.29.tar.gz']
  }

  file { '/usr/local/src/phpfarm/src/custom/options-5.3.29.sh':
    ensure => present,
    source => 'puppet:///modules/build/usr/local/src/phpfarm/src/custom/options-5.3.29.sh',
    mode => 755,
    require => Bash_exec['cp -r /tmp/php-5.3.29 /usr/local/src/phpfarm/src/php-5.3.29']
  }

  bash_exec { '/usr/local/src/phpfarm/src/main.sh 5.3.29':
    timeout => 0,
    require => File['/usr/local/src/phpfarm/src/custom/options-5.3.29.sh']
  }

  bash_exec { 'rm -r /usr/local/src/phpfarm/src/php-5.3.29':
    require => Bash_exec['/usr/local/src/phpfarm/src/main.sh 5.3.29']
  }

  bash_exec { 'CP=1 && cp -r /tmp/php-5.3.29 /usr/local/src/phpfarm/src/php-5.3.29':
    require => Bash_exec['rm -r /usr/local/src/phpfarm/src/php-5.3.29']
  }

  bash_exec { 'cp /src/php/build/modules/build/files/usr/local/src/phpfarm/src/custom/options-5.3.29-fpm.sh /usr/local/src/phpfarm/src/custom/options-5.3.29.sh':
    require => Bash_exec['CP=1 && cp -r /tmp/php-5.3.29 /usr/local/src/phpfarm/src/php-5.3.29']
  }

  bash_exec { 'PHPFPM=1 && /usr/local/src/phpfarm/src/main.sh 5.3.29':
    timeout => 0,
    require => Bash_exec['cp /src/php/build/modules/build/files/usr/local/src/phpfarm/src/custom/options-5.3.29-fpm.sh /usr/local/src/phpfarm/src/custom/options-5.3.29.sh']
  }

  bash_exec { 'rm -rf /usr/local/src/phpfarm/src/php-5.3.29':
    require => Bash_exec['PHPFPM=1 && /usr/local/src/phpfarm/src/main.sh 5.3.29']
  }

  file { '/usr/local/src/phpfarm/inst/php-5.3.29/etc/php-fpm.conf':
    ensure => present,
    source => 'puppet:///modules/build/usr/local/src/phpfarm/inst/php-5.3.29/etc/php-fpm.conf',
    mode => 644,
    require => Bash_exec['PHPFPM=1 && /usr/local/src/phpfarm/src/main.sh 5.3.29']
  }

  bash_exec { 'switch-phpfarm 5.3.29':
    require => Bash_exec['PHPFPM=1 && /usr/local/src/phpfarm/src/main.sh 5.3.29']
  }
}
