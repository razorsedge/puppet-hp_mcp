Puppet HP Management Component Pack Module
==========================================

master branch: [![Build Status](https://secure.travis-ci.org/razorsedge/puppet-hp_mcp.png?branch=master)](http://travis-ci.org/razorsedge/puppet-hp_mcp)
develop branch: [![Build Status](https://secure.travis-ci.org/razorsedge/puppet-hp_mcp.png?branch=develop)](http://travis-ci.org/razorsedge/puppet-hp_mcp)

Introduction
------------

This module manages the installation of the hardware monitoring aspects of the HP
[Management Component Pack](http://h18004.www1.hp.com/products/servers/linux/linuxcommunity/index.html)
from the [Software Delivery Repository](http://downloads.linux.hpe.com/SDR/).  It
does not support the HP kernel drivers.

This module currently only works on CentOS and Oracle Linux distributions.

Actions:

* Installs the MCP YUM repository.
* Installs the HP Health packages and services.
* Installs the HP SNMP Agent package, service, and configuration.
* Installs the HP Systems Management Homepage packages, service, and configuration.

OS Support:

* CentOS       - tested on CentOS 6.4
* Oracle Linux - supported but untested
* Asianux      - presently unsupported (patches welcome)
* Ubuntu       - presently unsupported (patches welcome)

Class documentation is available via puppetdoc.

Examples
--------

```puppet
include hp_mcp
```

```puppet
# Parameterized Class:
class { 'hp_mcp':
  install_smh               => true,
  smh_gid                   => 1000,
  smh_uid                   => 2000,
  cmamgmtstationrocommstr   => 'community',
  cmamgmtstationroipordns   => 'hpsim.example.com workstation.example.com',
  cmatrapdestinationcommstr => 'public',
  cmatrapdestinationipordns => 'hpsim.example.com',
}
```

Notes
-----

* Only tested on CentOS 6.4 x86_64 on a HP DL360 G5.

Issues
------

* None

TODO
----

* None

Contributing
------------

Please see DEVELOP.md for contribution information.

License
-------

Please see LICENSE file.

Copyright
---------

Copyright (C) 2013 Mike Arnold <mike@razorsedge.org>

[razorsedge/puppet-hp_mcp on GitHub](https://github.com/razorsedge/puppet-hp_mcp)

[razorsedge/hp_mcp on Puppet Forge](http://forge.puppetlabs.com/razorsedge/hp_mcp)

