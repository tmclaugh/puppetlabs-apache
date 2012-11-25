# Class: apache
#
# This class installs Apache
#
# Parameters:
#
# Actions:
#   - Install Apache
#   - Manage Apache service
#
# Requires:
#
# Sample Usage:
#
class apache (
  $service_enable = true
) {
  include apache::params

  package { 'httpd':
    ensure => installed,
    name   => $apache::params::apache_name,
  }

  # true/false is sufficient for both ensure and enable
  validate_bool($service_enable)

  service { 'httpd':
    ensure    => $service_enable,
    name      => $apache::params::apache_name,
    enable    => $service_enable,
    subscribe => Package['httpd'],
  }

  file { 'httpd_vdir':
    ensure  => directory,
    path    => $apache::params::vdir,
    recurse => true,
    purge   => true,
    notify  => Service['httpd'],
    require => Package['httpd'],
  }

  if $::osfamily == 'redhat' or $::operatingsystem == 'amazon' {
    file {'httpd_vdir_conf':
      ensure  => present,
      path    => $apache::params::confd,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('apache/vhost.conf.erb'),
      notify  => Service['httpd'],
      require => Package['httpd'],
  }

  if $apache::params::mod_dir {
    file { $apache::params::mod_dir:
      ensure  => directory,
      require => Package['httpd'],
    } -> A2mod <| |>
    resources { 'a2mod':
      purge => true,
    }
  }
}
