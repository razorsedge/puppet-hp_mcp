# == Class: hp_mcp::params
#
# This class handles OS-specific configuration of the hp_mcp module.  It
# looks for variables in top scope (probably from an ENC such as Dashboard).  If
# the variable doesn't exist in top scope, it falls back to a hard coded default
# value.
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
#
class hp_mcp::params {
  $gid          = '490'
  $uid          = '490'

  # Customize these values if you (for example) mirror public YUM repos to your
  # internal network.
  $yum_priority = '50'
  $yum_protect  = '0'

  # If we have a top scope variable defined, use it, otherwise fall back to a
  # hardcoded value.
  $yum_server = $::hp_mcp_yum_server ? {
    undef   => 'http://downloads.linux.hpe.com',
    default => $::hp_mcp_yum_server,
  }

  $mcp_version = $::hp_mcp_mcp_version ? {
    undef   => 'current',
    default => $::hp_mcp_mcp_version,
  }

### The following parameters should not need to be changed.

  $ensure = $::hp_mcp_ensure ? {
    undef => 'present',
    default => $::hp_mcp_ensure,
  }

  $service_ensure = $::hp_mcp_service_ensure ? {
    undef => 'running',
    default => $::hp_mcp_service_ensure,
  }

  # Since the top scope variable could be a string (if from an ENC), we might
  # need to convert it to a boolean.
  $autoupgrade = $::hp_mcp_autoupgrade ? {
    undef => false,
    default => $::hp_mcp_autoupgrade,
  }
  if is_string($autoupgrade) {
    $safe_autoupgrade = str2bool($autoupgrade)
  } else {
    $safe_autoupgrade = $autoupgrade
  }

  $service_enable = $::hp_mcp_service_enable ? {
    undef => true,
    default => $::hp_mcp_service_enable,
  }
  if is_string($service_enable) {
    $safe_service_enable = str2bool($service_enable)
  } else {
    $safe_service_enable = $service_enable
  }

  $gpg_path = '/SDR/'

  case $::operatingsystem {
    'CentOS': {
      $yum_path = '/SDR/repo/mcp/CentOS/$releasever/$basearch/'
      case $::operatingsystemrelease {
        /^5.[0-2]$/: {
          $ipmi_package_name = 'hp-OpenIPMI'
          $ilo_package_ensure = 'present'
          $ilo_service_ensure = 'running'
          $ilo_service_enable = true
        }
        /^5.[3-4]$/: {
          $ipmi_package_name = 'hp-OpenIPMI'
          $ilo_package_ensure = 'absent'
          $ilo_service_ensure = undef
          $ilo_service_enable = undef
        }
        default: {
          $ipmi_package_name = 'OpenIPMI'
          $ilo_package_ensure = 'absent'
          $ilo_service_ensure = undef
          $ilo_service_enable = undef
        }
      }
      case $::operatingsystemrelease {
        /^5/: { }
        default: {
          $arrayweb_package_name = 'hpssa'
          $arraycli_package_name = 'hpssacli'
        }
      }
    }
    'OracleLinux', 'OEL': {
      $yum_path = '/SDR/repo/mcp/Oracle/$releasever/$basearch/'
      case $::operatingsystemrelease {
        /^5.[0-2]$/: {
          $ipmi_package_name = 'hp-OpenIPMI'
          $ilo_package_ensure = 'present'
          $ilo_service_ensure = 'running'
          $ilo_service_enable = true
        }
        /^5.[3-4]$/: {
          $ipmi_package_name = 'hp-OpenIPMI'
          $ilo_package_ensure = 'absent'
          $ilo_service_ensure = undef
          $ilo_service_enable = undef
        }
        default: {
          $ipmi_package_name = 'OpenIPMI'
          $ilo_package_ensure = 'absent'
          $ilo_service_ensure = undef
          $ilo_service_enable = undef
        }
      }
      case $::operatingsystemrelease {
        /^5/: { }
        /^6/: {
          $arrayweb_package_name = 'cpqacuxe'
          $arraycli_package_name = 'hpacucli'
        }
        default: {
          $arrayweb_package_name = 'hpssa'
          $arraycli_package_name = 'hpssacli'
        }
      }
    }
    # If we are not on a supported OS, do not do anything.
    default: { }
  }
}
