class apache::mod::proxy (
  $proxy_requests = "Off"
) {
  apache::mod { 'proxy': }
  # Template uses $proxy_requests
  file { "${apache::params::confd}/proxy.conf":
    ensure  => present,
    content => template('apache/mod/proxy.conf.erb'),
  }
}
