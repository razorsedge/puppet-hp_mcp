# == Class: hp_mcp::hphealth
#
# This class handles installation of the HP Management Component Pack Health
# Agent.
#
# === Parameters:
#
# [*ensure*]
#   Ensure if present or absent.
#   Default: present
#
# [*autoupgrade*]
#   Upgrade package automatically, if there is a newer version.
#   Default: false
#
# [*service_ensure*]
#   Ensure if service is running or stopped.
#   Default: running
#
# [*service_enable*]
#   Start service at boot.
#   Default: true
#
# [*install_old_acu_tools*]
#   Whether to install the old HP Array Configuration Utilities (hpacucli and
#   cpqacuxe).
#   Default: false
#
# === Actions:
#
# Installs the HP System Health Application and Command Line Utilities.
# Installs the RILOE II/iLO online configuration utility.
# Installs the HP Command Line Array Configuration Utility.
# Installs OpenIPMI drivers and/or HP iLO Channel Interface Driver dependent
# upon OS version.
#
# === Requires:
#
# Class['hp_mcp::repo']
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
#
class hp_mcp::hphealth (
  $ensure                = 'present',
  $autoupgrade           = false,
  $service_ensure        = 'running',
  $service_enable        = true,
  $install_old_acu_tools = false
) inherits hp_mcp::params {
  # Validate our booleans
  validate_bool($autoupgrade)
  validate_bool($service_enable)
  validate_bool($install_old_acu_tools)

  case $ensure {
    /(present)/: {
      if $autoupgrade == true {
        $package_ensure = 'latest'
      } else {
        $package_ensure = 'present'
      }

      if $service_ensure in [ running, stopped ] {
        $service_ensure_real = $service_ensure
        $service_enable_real = $service_enable
      } else {
        fail('service_ensure parameter must be running or stopped')
      }
    }
    /(absent)/: {
      $package_ensure = 'absent'
      $service_ensure_real = 'stopped'
      $service_enable_real = false
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  case $::manufacturer {
    'HP': {
      #Class['hp_mcp::repo'] -> Class['hp_mcp::hphealth']

      # hp-OpenIPMI is only required on older EL5 releases.  From EL5.5, it is
      # replaced by OpenIPMI.
      package { 'hp-OpenIPMI':
        ensure => $package_ensure,
        name   => $hp_mcp::params::ipmi_package_name,
      }

      if ! defined(Package['libxslt']) {
        package { 'libxslt':
          ensure => 'present',
        }
      }

      package { 'hponcfg':
        ensure  => $package_ensure,
        require => Package['libxslt'],
      }

      package { 'hp-health':
        ensure => $package_ensure,
      }

      if $hp_mcp::params::arraycli_package_name {
        package { $hp_mcp::params::arraycli_package_name:
          ensure => $package_ensure,
        }
      }

      if $install_old_acu_tools {
        $hpacucli_package_ensure = $package_ensure
      } else {
        $hpacucli_package_ensure = 'absent'
      }
      ensure_packages('hpacucli', {ensure => $hpacucli_package_ensure})

      service { 'hp-health':
        ensure     => $service_ensure_real,
        enable     => $service_enable_real,
        hasrestart => true,
        hasstatus  => true,
        require    => [ Package['hp-health'], Package['hp-OpenIPMI'], ],
      }

      # TODO: What happens to Package['hp-ilo'] when $ensure = absent?
      # hp-ilo is only required on older EL5 releases.  From EL5.3, it is no
      # longer needed.
      package { 'hp-ilo':
        ensure => $hp_mcp::params::ilo_package_ensure,
      }

      # TODO: What happens to Service['hp-ilo'] when $ensure = absent?
      service { 'hp-ilo':
        ensure     => $hp_mcp::params::ilo_service_ensure,
        enable     => $hp_mcp::params::ilo_service_enable,
        hasrestart => true,
        hasstatus  => true,
        require    => Package['hp-ilo'],
      }
    }
    # If we are not on HP hardware, do not do anything.
    default: { }
  }
}
