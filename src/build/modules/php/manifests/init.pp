define bash_exec (
  $command = $name,
  $user = 'root',
  $creates = undef,
  $cwd = undef,
  $environment = undef,
  $group = undef,
  $logoutput = undef,
  $onlyif = undef,
  $path = undef,
  $provider = "posix",
  $refresh = undef,
  $refreshonly = undef,
  $returns = undef,
  $timeout = undef,
  $tries = undef,
  $try_sleep = undef,
  $umask = undef,
  $unless = undef
) {
  $escaped_command = regsubst($command, "\"", "\\\"", 'G')

  if $unless == undef {
    $escaped_unless = undef
  } else {
    $unless_with_escaped_quotes = regsubst($unless, "\"", "\\\"", 'G')
    $escaped_unless = "/bin/su -l ${user} -c \"/bin/bash --login -c \\\"${unless_with_escaped_quotes}\\\"\""
  }

  if $onlyif == undef {
    $escaped_onlyif = undef
  } else {
    $onlyif_with_escaped_quotes = regsubst($onlyif, "\"", "\\\"", 'G')
    $escaped_onlyif = "/bin/su -l ${user} -c \"/bin/bash --login -c \\\"${onlyif_with_escaped_quotes}\\\"\""
  }

  exec { $name:
    command => "/bin/su -l ${user} -c \"/bin/bash --login -c \\\"${escaped_command}\\\"\"",
    creates => $creates,
    cwd => $cwd,
    environment => $environment,
    group => $group,
    logoutput => $logoutput,
    onlyif => $escaped_onlyif,
    path => $path,
    provider => $provider,
    refresh => $refresh,
    refreshonly => $refreshonly,
    returns => $returns,
    timeout => $timeout,
    tries => $tries,
    try_sleep => $try_sleep,
    umask => $umask,
    unless => $escaped_unless
  }
}

class php {
  require php::packages
  require php::phpfarm
  require php::supervisor
  require php::freetds

  bash_exec { 'mkdir -p /phpfarm/inst/php-5.3.29/etc/conf.d': }

  bash_exec { 'mkdir -p /phpfarm/inst/php-5.3.29/lib/php/extensions/no-debug-non-zts-20090626': }

  file { '/tmp/php-5.3.29.tar.gz':
    ensure => present,
    source => 'puppet:///modules/php/tmp/php-5.3.29.tar.gz'
  }

  bash_exec { 'tar xzf php-5.3.29.tar.gz':
    cwd => '/tmp',
    require => File['/tmp/php-5.3.29.tar.gz']
  }

  bash_exec { 'cp -r php-5.3.29 /phpfarm/src/php-5.3.29':
    cwd => '/tmp',
    require => Bash_exec['tar xzf php-5.3.29.tar.gz']
  }

  file { '/phpfarm/src/custom/options-5.3.29.sh':
    ensure => present,
    source => 'puppet:///modules/php/phpfarm/src/custom/options-5.3.29.sh',
    mode => 755,
    require => Bash_exec['cp -r php-5.3.29 /phpfarm/src/php-5.3.29']
  }

  bash_exec { '/phpfarm/src/main.sh 5.3.29':
    timeout => 0,
    require => File['/phpfarm/src/custom/options-5.3.29.sh']
  }

  bash_exec { 'rm -r /phpfarm/src/php-5.3.29':
    require => Bash_exec['/phpfarm/src/main.sh 5.3.29']
  }

  bash_exec { 'CP=1 && cp -r php-5.3.29 /phpfarm/src/php-5.3.29':
    cwd => '/tmp',
    require => Bash_exec['rm -r /phpfarm/src/php-5.3.29']
  }

  bash_exec { 'cp /src/build/modules/php/files/phpfarm/src/custom/options-5.3.29-fpm.sh /phpfarm/src/custom/options-5.3.29.sh':
    cwd => '/tmp',
    require => Bash_exec['CP=1 && cp -r php-5.3.29 /phpfarm/src/php-5.3.29']
  }

  bash_exec { 'PHPFPM=1 && /phpfarm/src/main.sh 5.3.29':
    timeout => 0,
    require => Bash_exec['cp /src/build/modules/php/files/phpfarm/src/custom/options-5.3.29-fpm.sh /phpfarm/src/custom/options-5.3.29.sh']
  }

  bash_exec { 'rm -rf /phpfarm/src/php-5.3.29':
    require => Bash_exec['PHPFPM=1 && /phpfarm/src/main.sh 5.3.29']
  }

  file { '/phpfarm/inst/php-5.3.29/etc/php-fpm.conf':
    ensure => present,
    source => 'puppet:///modules/php/phpfarm/inst/php-5.3.29/etc/php-fpm.conf',
    mode => 644,
    require => Bash_exec['PHPFPM=1 && /phpfarm/src/main.sh 5.3.29']
  }

  bash_exec { 'switch-phpfarm 5.3.29':
    require => Bash_exec['PHPFPM=1 && /phpfarm/src/main.sh 5.3.29']
  }
}
