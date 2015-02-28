class memcached (
  $enabled    = true,
  $port       = 11211,
  $listen     = '127.0.0.1',
  $size       = '64',
  $conn       = 1024,
  $item_size  = '1m',
  $user       = $::operatingsystem ? {
    'centos'  => 'memcached',
    'ubuntu'  => 'memcache',
    'debian'  => 'nobody',
  },

) {

  validate_bool($enabled)

  case $::operatingsystem {
    'centos': {
      file { '/etc/sysconfig/memcached':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('memcached/sysconfig_memcached.erb'),
        notify  => Service['memcached'],
      }
      package { 'policycoreutils-python':
        ensure  => installed,
      }
    }

    'debian', 'ubuntu': {
      file { '/etc/memcached.conf':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('memcached/memcached.conf.erb'),
        notify  => Service['memcached'],
      }
      file { '/etc/default/memcached':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('memcached/default_memcached.erb'),
        notify  => Service['memcached'],
      }
    }
  }

  file { '/etc/init.d/memcached':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => "puppet:///modules/memcached/init_memcached_${osfamily}",
  }

  $ensure = $enabled ? {
    true    => 'running',
    false   => 'stopped',
  }

  package { 'memcached':
    ensure  => installed,
  }

  service { 'memcached':
    ensure  => $ensure,
    enable  => $enabled,
    require => File['/etc/init.d/memcached'],
  }
}
