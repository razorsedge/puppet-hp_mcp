# == Class: hp_mcp::repo
#
# This class handles installing the MCP software repositories.
#
# === Parameters:
#
# [*ensure*]
#   Ensure if present or absent.
#   Default: present
#
# [*yum_server*]
#   URI of the YUM server.
#   Default: http://downloads.linux.hp.com
#
# [*yum_path*]
#   The path to add to the $yum_server URI.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*mcp_version*]
#   The version of MCP to install.
#   Default: current
#
# === Actions:
#
# Installs YUM repository configuration files.
#
# === Requires:
#
# Nothing.
#
# === Sample Usage:
#
#   class { 'hp_mcp::repo':
#     mcp_version => '9.10',
#   }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
#
class hp_mcp::repo (
  $ensure      = $hp_mcp::params::ensure,
  $yum_server  = $hp_mcp::params::yum_server,
  $yum_path    = $hp_mcp::params::yum_path,
  $gpg_path    = $hp_mcp::params::gpg_path,
  $mcp_version = $hp_mcp::params::mcp_version
) inherits hp_mcp::params {
  case $ensure {
    /(present)/: {
      $enabled = '1'
    }
    /(absent)/: {
      $enabled = '0'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  case $::manufacturer {
    'HP': {
      case $::operatingsystem {
        'CentOS', 'OEL', 'OracleLinux': {
          yumrepo { 'HP-mcp':
            descr    => 'HP Software Delivery Repository for Management Component Pack',
            enabled  => $enabled,
            gpgcheck => 1,
            gpgkey   => "${yum_server}${gpg_path}GPG-KEY-ManagementComponentPack",
            baseurl  => "${yum_server}${yum_path}${mcp_version}/",
            priority => $hp_mcp::params::yum_priority,
            protect  => $hp_mcp::params::yum_protect,
          }
        }
        default: { }
      }
    }
    # If we are not on HP hardware, do not do anything.
    default: { }
  }
}
