name 'razorsedge-hp_mcp'
version '0.0.1'

author 'razorsedge'
license 'Apache License, Version 2.0'
project_page 'https://github.com/razorsedge/puppet-hp_mcp'
source 'git://github.com/razorsedge/puppet-hp_mcp.git'
summary 'Puppet module to manage HP Management Component Pack hardware monitoring installation.'
description 'This module manages the installation of the hardware monitoring aspects of the HP Management Component Pack from the Software Delivery Repository.  It does not support the HP kernel drivers.

This module currently only works on CentOS, Oracle Linux, and Red Hat Enterprise Linux distributions.

Actions:

    Installs the MCP YUM repository.
    Installs the HP Health packages and services.
    Installs the HP Systems Management Homepage packages, service, and configuration.
    Installs the HP SNMP Agent package, service, and configuration.

OS Support:
    RedHat family  - tested on CentOS 6.3
    Fedora         - presently unsupported (patches welcome)
    SuSE family    - presently unsupported (patches welcome)
    Debian family  - presently unsupported (patches welcome)
    Asianux        - presently unsupported (patches welcome)

Class documentation is available via puppetdoc.'
dependency 'puppetlabs/stdlib', '>=2.3.0'
dependency 'razorsedge/snmp', '>=0.0.1'

# Generate the changelog file
#system("git-log-to-changelog > CHANGELOG")
#$? == 0 or fail "changelog generation #{$?}!"
