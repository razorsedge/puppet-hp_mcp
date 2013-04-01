Puppet HP Management Component Pack Module
==========================================

master branch: [![Build Status](https://secure.travis-ci.org/razorsedge/puppet-hp_mcp.png?branch=master)](http://travis-ci.org/razorsedge/puppet-hp_mcp)
develop branch: [![Build Status](https://secure.travis-ci.org/razorsedge/puppet-hp_mcp.png?branch=develop)](http://travis-ci.org/razorsedge/puppet-hp_mcp)

Introduction
------------

This module manages the installation of the hardware monitoring aspects of the HP
[Proliant Support Pack](http://h18004.www1.hp.com/products/servers/linux/linuxcommunity/index.html)
from the [Software Delivery Repository](http://downloads.linux.hp.com/SDR/).  It
does not support the HP kernel drivers.

This module currently only works on CentOS and Oracle Linux distributions.

Actions:

* Installs the MCP YUM repository.
* Installs the HP Health packages and services.
* Installs the HP Systems Management Homepage packages, service, and configuration.
* Installs the HP SNMP Agent package, service, and configuration.

OS Support:

* CentOS       - tested on CentOS 6.3
* Oracle Linux - supported but untested
* Asianux      - presently unsupported (patches welcome)
* Fedora       - presently unsupported (patches welcome)
* Ubuntu       - presently unsupported (patches welcome)

Class documentation is available via puppetdoc.

Examples
--------

      # Parameterized Class:
      class { 'snmp': }
      class { 'hp_mcp':
        smh_gid => '1001',
        smh_uid => '1001',
        cmalocalhostrwcommstr => 'SomeSecureString',
      }

      # Include only on HP ProLiant Gen8 or newer platforms.
      class { 'hp_mcp::hpams': }

Notes
-----

* Only tested on CentOS 6.3 x86_64 on a HP DL140 G2.

Issues
------

* None

TODO
----

* None

License
-------

Please see LICENSE file.

Copyright
---------

Copyright (C) 2013 Mike Arnold <mike@razorsedge.org>

[razorsedge/puppet-hp_mcp on GitHub](https://github.com/razorsedge/puppet-hp_mcp)

[razorsedge/hp_mcp on Puppet Forge](http://forge.puppetlabs.com/razorsedge/hp_mcp)

