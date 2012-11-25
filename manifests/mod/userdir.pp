class apache::mod::userdir (
  $dir = 'public_html',
) {
  apache::mod { 'userdir': }

  # Template uses $dir
  file { "${apache::params::confd}/userdir.conf":
    ensure  => present,
    content => template('apache/mod/userdir.conf.erb'),
  }
}
