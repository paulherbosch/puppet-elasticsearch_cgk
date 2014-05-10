class elasticsearch::package($version = 'present') {

  case $version {
    'present', 'latest': { $version_real = $version }
    default:             { fail('Class[elasticsearch::package]: parameter version must be present or latest') }
  }

  package { 'elasticsearch' :
    ensure => $version_real
  }

}
