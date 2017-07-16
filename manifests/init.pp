# == Class: hp_mcp
#
# This class handles installation of the HP Management Component Pack.
#
# === Parameters:
#
# [*ensure*]
#   Ensure if present or absent.
#   Default: present
#
# [*smh_gid*]
#   The group ID of the SMH user.
#   Default: 490
#
# [*smh_uid*]
#   The user ID of the SMH user.
#   Default: 490
#
# [*install_smh*]
#   Whether to install the HP System Management Homepage.
#   Default: true
#
# === Actions:
#
# Wraps the installation of all HP MCP subcomponents except for the Agentless
# Monitoring Service.  Do not call this class if you just want AMS.
#
# === Requires:
#
# Nothing.
#
# === Sample Usage:
#
#   class { 'hp_mcp': }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
#
class hp_mcp (
  $ensure                    = $hp_mcp::params::ensure,
  $autoupgrade               = $hp_mcp::params::safe_autoupgrade,
  $service_ensure            = $hp_mcp::params::service_ensure,
  $service_enable            = $hp_mcp::params::safe_service_enable,
  $smh_gid                   = $hp_mcp::params::gid,
  $smh_uid                   = $hp_mcp::params::uid,
  $yum_server                = $hp_mcp::params::yum_server,
  $yum_path                  = $hp_mcp::params::yum_path,
  $gpg_path                  = $hp_mcp::params::gpg_path,
  $mcp_version               = $hp_mcp::params::mcp_version,
  $cmasyscontact             = undef,
  $cmasyslocation            = undef,
  $cmalocalhostrwcommstr     = undef,
  $cmamgmtstationrocommstr   = undef,
  $cmamgmtstationroipordns   = undef,
  $cmatrapdestinationcommstr = undef,
  $cmatrapdestinationipordns = undef,
  $manage_snmp               = true,
  $install_smh               = true
) inherits hp_mcp::params {
  # Validate our booleans
  validate_bool($autoupgrade)
  validate_bool($service_enable)
  validate_bool($manage_snmp)
  validate_bool($install_smh)

  case $ensure {
    /(present)/: {
      $user_ensure = 'present'
    }
    /(absent)/: {
      $user_ensure = 'absent'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  case $::manufacturer {
    'HP': {
      case $::operatingsystem {
        'CentOS', 'OEL', 'OracleLinux': {
          @group { 'hpsmh':
            ensure => $user_ensure,
            gid    => $smh_gid,
          }

          @user { 'hpsmh':
            ensure => $user_ensure,
            uid    => $smh_uid,
            gid    => 'hpsmh',
            home   => '/opt/hp/hpsmh',
            shell  => '/sbin/nologin',
          }

          anchor { 'hp_mcp::begin': }
          anchor { 'hp_mcp::end': }

          class { '::hp_mcp::repo':
            ensure      => $ensure,
            yum_server  => $yum_server,
            yum_path    => $yum_path,
            gpg_path    => $gpg_path,
            mcp_version => $mcp_version,
          }
          class { '::hp_mcp::hphealth':
            ensure         => $ensure,
            autoupgrade    => $autoupgrade,
            service_ensure => $service_ensure,
            service_enable => $service_enable,
          }
          class { '::hp_mcp::hpsnmp':
            ensure                    => $ensure,
            autoupgrade               => $autoupgrade,
            service_ensure            => $service_ensure,
            service_enable            => $service_enable,
            cmasyscontact             => $cmasyscontact,
            cmasyslocation            => $cmasyslocation,
            cmalocalhostrwcommstr     => $cmalocalhostrwcommstr,
            cmamgmtstationrocommstr   => $cmamgmtstationrocommstr,
            cmamgmtstationroipordns   => $cmamgmtstationroipordns,
            cmatrapdestinationcommstr => $cmatrapdestinationcommstr,
            cmatrapdestinationipordns => $cmatrapdestinationipordns,
            manage_snmp               => $manage_snmp,
          }
          if $install_smh {
            class { '::hp_mcp::hpsmh':
              ensure         => $ensure,
              autoupgrade    => $autoupgrade,
              service_ensure => $service_ensure,
              service_enable => $service_enable,
            }
            Anchor['hp_mcp::begin']
            -> Class['hp_mcp::repo']
            -> Class['hp_mcp::hphealth']
            -> Class['hp_mcp::hpsnmp']
            -> Class['hp_mcp::hpsmh']
            -> Anchor['hp_mcp::end']
          } else {
            Anchor['hp_mcp::begin']
            -> Class['hp_mcp::repo']
            -> Class['hp_mcp::hphealth']
            -> Class['hp_mcp::hpsnmp']
            -> Anchor['hp_mcp::end']
          }
        }
        # If we are not on a supported OS, do not do anything.
        default: { }
      }
    }
    # If we are not on HP hardware, do not do anything.
    default: { }
  }
}
