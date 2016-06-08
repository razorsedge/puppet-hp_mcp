# == Class: hp_mcp::hpsmh
#
# This class handles installation of the HP Management Component Pack System
# Management Homepage.
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
# [*admin_group*]
#   List of OS users to put in the SMH admin group, separated by semicolons.
#   Default: empty
#
# [*operator_group*]
#   List of OS users to put in the SMH operator group, separated by semicolons.
#   Default: empty
#
# [*user_group*]
#   List of OS users to put in the SMH user group, separated by semicolons.
#   Default: empty
#
# [*allow_default_os_admin*]
#   Allow the OS root user to login to SMH.
#   Default: true
#
# [*anonymous_access*]
#   Allow an unauthenticated user to log in to SMH.
#   Default: false
#
# [*localaccess_enabled*]
#   Enable unauthenticated access from localhost.
#   Default: false
#
# [*localaccess_type*]
#   The type of authorization when localaccess_enabled=true.
#   administrator|anonymous
#   Default: Anonymous
#
# [*trustmode*]
#   ?
#   TrustByName|TrustByCert|TrustByAll
#   Default: TrustByCert
#
# [*xenamelist*]
#   A list of trusted server hostnames.
#   Default: empty
#
# [*ip_binding*]
#   Bind SMH to a specific IP address on the host?
#   Default: false
#
# [*ip_binding_list*]
#   A list IP addresses and/or IP address/netmask pairs, separated by
#   semicolons.
#   Default: empty
#
# [*ip_restricted_logins*]
#   Restrict logins to SMH via IP address?
#   Default: false
#
# [*ip_restricted_include*]
#   A list of IP addresses, separated by semicolons.
#   Default: empty
#
# [*ip_restricted_exclude*]
#   A list of IP addresses, separated by semicolons.
#   Default: empty
#
# [*autostart*]
#   ?
#   Default: false
#
# [*timeoutsmh*]
#   ?
#   Default: 30
#
# [*port2301*]
#   Whether to enable unencrypted port 2301 access.
#   Default: true
#
# [*iconview*]
#   ?
#   Default: false
#
# [*box_order*]
#   ?
#   Default: status
#
# [*box_item_order*]
#   ?
#   Default: status
#
# [*session_timeout*]
#   ?
#   Default: 15
#
# [*ui_timeout*]
#   ?
#   Default: 120
#
# [*httpd_error_log*]
#   ?
#   Default: false
#
# [*multihomed*]
#   A list of hostnames and IP addresses, separated by semicolons.
#   Default: empty
#
# [*rotate_logs_size*]
#   ?
#   Default: 5
#
# [*install_old_acu_tools*]
#   Whether to install the old HP Array Configuration Utilities (hpacucli and
#   cpqacuxe).
#   Default: false
#
# === Actions:
#
# Installs and configures the HP System Management Homepage.
# Installs the HP Array Configuration Utility.
# Installs the HP Insight Diagnostics.
#
# === Requires:
#
# Class['hp_mcp']
# Class['hp_mcp::repo']
# Class['hp_mcp::hpsnmp']
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2012 Mike Arnold, unless otherwise noted.
#
class hp_mcp::hpsmh (
  $ensure                 = 'present',
  $autoupgrade            = false,
  $service_ensure         = 'running',
  $service_enable         = true,
  $admin_group            = undef,
  $operator_group         = undef,
  $user_group             = undef,
  $allow_default_os_admin = 'true', # lint:ignore:quoted_booleans
  $anonymous_access       = 'false', # lint:ignore:quoted_booleans
  $localaccess_enabled    = 'false', # lint:ignore:quoted_booleans
  $localaccess_type       = 'Anonymous',
  $trustmode              = 'TrustByCert',
  $xenamelist             = undef,
  $ip_binding             = 'false', # lint:ignore:quoted_booleans
  $ip_binding_list        = undef,
  $ip_restricted_logins   = 'false', # lint:ignore:quoted_booleans
  $ip_restricted_include  = undef,
  $ip_restricted_exclude  = undef,
  $autostart              = 'false', # lint:ignore:quoted_booleans
  $timeoutsmh             = 30,
  $port2301               = 'true', # lint:ignore:quoted_booleans
  $iconview               = 'false', # lint:ignore:quoted_booleans
  $box_order              = 'status',
  $box_item_order         = 'status',
  $session_timeout        = 15,
  $ui_timeout             = 120,
  $httpd_error_log        = 'false', # lint:ignore:quoted_booleans
  $multihomed             = undef,
  $rotate_logs_size       = 5,
  $install_old_acu_tools  = false
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
      $file_ensure = 'present'
      $file_ensure_link = 'link'
      if $service_ensure in [ running, stopped ] {
        $service_ensure_real = $service_ensure
        $service_enable_real = $service_enable
      } else {
        fail('service_ensure parameter must be running or stopped')
      }
    }
    /(absent)/: {
      $package_ensure = 'absent'
      $file_ensure = 'absent'
      $file_ensure_link = 'absent'
      $service_ensure_real = 'stopped'
      $service_enable_real = false
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  case $::manufacturer {
    'HP': {
      #Class['hp_mcp'] -> Class['hp_mcp::repo'] -> Class['hp_mcp::hpsnmp'] ->
      #Class['hp_mcp::hpsmh']

      realize Group['hpsmh']
      realize User['hpsmh']

      if $hp_mcp::params::arrayweb_package_name {
        package { $hp_mcp::params::arrayweb_package_name:
          ensure => $package_ensure,
          notify => Service['hpsmhd'],
        }
      }

      if $install_old_acu_tools {
        $hpacucli_package_ensure = $package_ensure
      } else {
        $hpacucli_package_ensure = 'absent'
      }
      ensure_packages('cpqacuxe', {ensure => $hpacucli_package_ensure})

      package { 'hpdiags':
        ensure  => $package_ensure,
        require => Package['hpsmh'],
        notify  => Service['hpsmhd'],
      }

      package { 'hp-smh-templates':
        ensure  => $package_ensure,
        require => Package['hpsmh'],
#        require => Package['hp-snmp-agents'],
        notify  => Service['hpsmhd'],
      }

      package { 'hpsmh':
        ensure  => $package_ensure,
      }

      # TODO: Figure out some dynamic way to use hpsmh-cert-host1
      # This file resource installs the cert from the HP SIM server into SMH so
      # that when clicking through to the host from SIM, the user is not
      # prompted for authentication.  Multiple certs can be specified.
#      file { 'hpsmh-cert-host1':
#        ensure  => $file_ensure,
#        mode    => '0644',
#        owner   => 'root',
#        group   => 'root',
#        path    => '/opt/hp/hpsmh/certs/host1.pem',
#        source  => 'puppet:///modules/hp_mcp/host1.pem',
#        require => Package['hpsmh'],
#        notify  => Service['hpsmhd'],
#      }

      # TODO: SMH server certs are in /etc/opt/hp/sslshare/{cert,file}.pem

      # TODO: Exec['smhconfig'] or File['hpsmhconfig']?
      file { 'hpsmhconfig':
        ensure  => $file_ensure,
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        path    => '/opt/hp/hpsmh/conf/smhpd.xml',
        content => template('hp_mcp/smhpd.xml.erb'),
        require => Package['hpsmh'],
        notify  => Service['hpsmhd'],
      }
#      exec { 'smhconfig':
#        command => '/opt/hp/hpsmh/sbin/smhconfig --trustmode=TrustByCert',
#        notify  => Service['hpsmhd'],
#      }

      service { 'hpsmhd':
        ensure     => $service_ensure_real,
        enable     => $service_enable_real,
        hasrestart => true,
        hasstatus  => true,
        require    => Package['hpsmh'],
      }

      file { '/var/spool/opt/hp/hpsmh/run/httpd.pid':
        ensure  => $file_ensure_link,
        target  => '/opt/hp/hpsmh/logs/httpd.pid',
        before  => Service['hpsmhd'],
        require => Package['hpsmh'],
      }
    }
    # If we are not on HP hardware, do not do anything.
    default: { }
  }
}
