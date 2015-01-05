puppet-memcached
================

A puppet module for managing one or more memcached instances on Ubuntu and CentOS.

## Description
This module installs and manages one or more memcached instances through defined types.  
It has been tested under Debian 6 and 7, Ubuntu 12.04 and CentOS 6.4.
For other Operating Systems, the defined type [memcached::instance](#memcachedinstance) may not work.  
This module also manages the port permissions for memcached in SElinux.  

## Usage

### memcached
Installs the memcached package.
Simple install:

    class {"memcached": }
    
Install with non-default settings:

    class {"memcached":
      enabled => true,
      port    => 11211,
      listen  => "127.0.0.1",
      size    => 64,
      conn    => 1024,
      user    => "memcached",
    }
    
* *conn : max current connections*
* *size : size in megabytes*

### memcached::instance
Creates an extra memcached instance.  
Simple:

    memcached::instance { "additional_1":
      port    => 11211,
    }

Advanced:

    memcached::instance { "additional_1":
      port    => 11211,
      listen  => "127.0.0.1",
      size    => 64,
      conn    => 1024,
      user    => "memcached",
    }


## Requirements:
* [puppetlabs/apt](https://forge.puppetlabs.com/puppetlabs/apt)
* [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)
