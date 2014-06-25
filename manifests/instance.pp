define memcached::instance (
  $port   = undef,
  $user   = $memcached::user,
  $listen = $memcached::listen,
  $size   = $memcached::size,
  $conn   = $memcached::conn,
) {

  include memcached

  if $port == undef {
    fail("You must at least enter a port number")
  }

  validate_re($port,'^112[0-9]{2}$')

  # Newer versions of puppet use newer facts; use what we have
  if $::lsbmajdistrelease {
    $major_release = $::lsbmajdistrelease
  }
  else {
    $major_release = $::operatingsystemmajrelease
  }

  case $::operatingsystem {
    centos: {
      if $major_release < 6 { fail("CentOS version 5 or lower not supported by this type.")}
      file { "/etc/sysconfig/memcached_${name}":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => 0644,
        content => template("memcached/sysconfig_memcached.erb"),
        notify  => Service['memcached'],
      }
      if $selinux_enforced {
        exec { "enable_selinux_port_${port}":
          command => "/bin/echo -e \"port -a -t memcache_port_t -p tcp ${port}\nport -a -t memcache_port_t -p udp ${port}\" | semanage -i -",
          unless  => "/usr/sbin/semanage port -l | grep memcache_port_t | grep -cw ${port} | grep -q 2",
          require => Package["policycoreutils-python"],
        }
      }
    }
    ubuntu: {
      if $major_release < 12 { fail("Ubuntu version 11.10 or lower not supported by this type.")}
      file { "/etc/memcached_${name}.conf":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => 0644,
        content => template("memcached/memcached.conf.erb"),
        notify  => Service['memcached'],
      }
    }
  }
}
