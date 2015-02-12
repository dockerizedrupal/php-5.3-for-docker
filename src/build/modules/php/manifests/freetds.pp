class php::freetds {
  file { '/tmp/freetds-stable.tgz':
    ensure => present,
    source => 'puppet:///modules/php/tmp/freetds-stable.tgz'
  }

  exec { 'tar xzf freetds-stable.tgz':
    cwd => '/tmp',
    path => ['/bin'],
    require => File['/tmp/freetds-stable.tgz']
  }

  exec { '/bin/bash -c "cd /tmp/freetds-0.91 && ./configure --prefix=/usr/local/freetds --enable-msdblib"':
    timeout => 0,
    require => Exec['tar xzf freetds-stable.tgz']
  }

  exec { '/bin/bash -c "cd /tmp/freetds-0.91 && make"':
    timeout => 0,
    require => Exec['/bin/bash -c "cd /tmp/freetds-0.91 && ./configure --prefix=/usr/local/freetds --enable-msdblib"']
  }

  exec { '/bin/bash -c "cd /tmp/freetds-0.91 && make install"':
    timeout => 0,
    require => Exec['/bin/bash -c "cd /tmp/freetds-0.91 && make"']
  }

  exec { 'cp include/tds.h /usr/local/freetds/include':
    cwd => '/tmp/freetds-0.91',
    path => ['/bin'],
    require => Exec['/bin/bash -c "cd /tmp/freetds-0.91 && make install"']
  }

  exec { 'cp src/tds/.libs/libtds.a /usr/local/freetds/lib':
    cwd => '/tmp/freetds-0.91',
    path => ['/bin'],
    require => Exec['cp include/tds.h /usr/local/freetds/include']
  }

  exec { '/bin/bash -c "echo \'include /usr/local/freetds/lib\' >> /etc/ld.so.conf"':
    require => Exec['cp src/tds/.libs/libtds.a /usr/local/freetds/lib']
  }

  file { '/usr/lib/x86_64-linux-gnu/libsybdb.so':
    ensure => link,
    target => '/usr/lib/x86_64-linux-gnu/libsybdb.so.5',
    require => Exec['/bin/bash -c "echo \'include /usr/local/freetds/lib\' >> /etc/ld.so.conf"']
  }

  exec { 'ldconfig -v':
    path => ['/sbin'],
    require => File['/usr/lib/x86_64-linux-gnu/libsybdb.so']
  }
}
