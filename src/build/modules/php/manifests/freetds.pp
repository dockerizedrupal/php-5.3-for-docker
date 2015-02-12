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

  file { '/usr/lib/x86_64-linux-gnu/libsybdb.so.5':
    ensure => link,
    target => '/usr/local/freetds/lib/libsybdb.so.5',
    require => Exec['/bin/bash -c "cd /tmp/freetds-0.91 && make install"']
  }

  exec { 'mkdir -p /usr/local/freetds/lib/x86_64-linux-gnu':
    path => ['/bin'],
    require => File['/usr/lib/x86_64-linux-gnu/libsybdb.so.5']
  }

  file { '/usr/local/freetds/lib/x86_64-linux-gnu/libsybdb.so':
    ensure => link,
    target => '/usr/local/freetds/lib/libsybdb.so.5',
    require => Exec['mkdir -p /usr/local/freetds/lib/x86_64-linux-gnu']
  }

  exec { '/bin/bash -c "echo \'include /usr/local/freetds/lib\' >> /etc/ld.so.conf"':
    require => File['/usr/local/freetds/lib/x86_64-linux-gnu/libsybdb.so']
  }

  exec { 'ldconfig -v':
    path => ['/sbin'],
    require => Exec['/bin/bash -c "echo \'include /usr/local/freetds/lib\' >> /etc/ld.so.conf"']
  }
}
