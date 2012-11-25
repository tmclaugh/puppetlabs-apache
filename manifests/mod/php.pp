class apache::mod::php {
  include apache::params
  apache::mod { 'php5': }
  file { "${apache::params::confd}/php.conf":
    ensure  => present,
    content => template('apache/mod/php.conf.erb'),
  }
}
