class elasticsearch_cgk::package(
  $version = undef,
  $versionlock = false
) {

  if ! $version {
    fail('Class[Elasticsearch_cgk::Package]: parameter version must be provided')
  }

  package { 'elasticsearch' :
    ensure => $version
  }

  case $versionlock {
    true: {
      packagelock { 'elasticsearch': }
    }
    false: {
      packagelock { 'elasticsearch': ensure => absent }
    }
    default: { fail('Class[Elasticsearch_cgk::Package]: parameter versionlock must be true or false')}
  }

}
