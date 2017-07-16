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
  $hp_mcp_yum_server = getvar('::hp_mcp_yum_server')
  if $hp_mcp_yum_server {
    $yum_server = $::hp_mcp_yum_server
  } else {
    $yum_server = 'http://downloads.linux.hpe.com'
  }

  $hp_mcp_mcp_version = getvar('::hp_mcp_mcp_version')
  if $hp_mcp_mcp_version {
    $mcp_version = $::hp_mcp_mcp_version
  } else {
    $mcp_version = 'current'
  }

### The following parameters should not need to be changed.

  $hp_mcp_ensure = getvar('::hp_mcp_ensure')
  if $hp_mcp_ensure {
    $ensure = $::hp_mcp_ensure
  } else {
    $ensure = 'present'
  }

  $hp_mcp_service_ensure = getvar('::hp_mcp_service_ensure')
  if $hp_mcp_service_ensure {
    $service_ensure = $::hp_mcp_service_ensure
  } else {
    $service_ensure = 'running'
  }

  # Since the top scope variable could be a string (if from an ENC), we might
  # need to convert it to a boolean.
  $hp_mcp_autoupgrade = getvar('::hp_mcp_autoupgrade')
  if $hp_mcp_autoupgrade {
    $autoupgrade = $::hp_mcp_autoupgrade
  } else {
    $autoupgrade = false
  }
  if is_string($autoupgrade) {
    $safe_autoupgrade = str2bool($autoupgrade)
  } else {
    $safe_autoupgrade = $autoupgrade
  }

  $hp_mcp_service_enable = getvar('::hp_mcp_service_enable')
  if $hp_mcp_service_enable {
    $service_enable = $::hp_mcp_service_enable
  } else {
    $service_enable = true
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
        /^6/: {
          $arrayweb_package_name = 'cpqacuxe'
          $arraycli_package_name = 'hpacucli'
        }
        /^7/: {
          $arrayweb_package_name = 'hpssa'
          $arraycli_package_name = 'hpssacli'
        }
        default: {
          $arrayweb_package_name = undef
          $arraycli_package_name = undef
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
        /^6/: {
          $arrayweb_package_name = 'cpqacuxe'
          $arraycli_package_name = 'hpacucli'
        }
        /^7/: {
          $arrayweb_package_name = 'hpssa'
          $arraycli_package_name = 'hpssacli'
        }
        default: {
          $arrayweb_package_name = undef
          $arraycli_package_name = undef
        }
      }
    }
    # If we are not on a supported OS, do not do anything.
    default: { }
  }
}
