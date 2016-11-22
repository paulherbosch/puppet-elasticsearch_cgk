# Class: elasticsearch_cgk
#
# This module manages elasticsearch
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class elasticsearch_cgk(
  $version = undef,
  $versionlock = false,
  $enable = true,
  $service_state = 'running',
  $cluster_name = 'elasticsearch',
  $data_dir = '/data/elasticsearch',
  $logs_dir = '/data/logs/elasticsearch',
  $heap_size = '1g',
  $mlock = 'false',
  $http_cors_enabled = false,
  $http_cors_origin = 'http://dummy.tld'
) {

  include stdlib

  anchor { 'elasticsearch_cgk::begin': }
  anchor { 'elasticsearch_cgk::end': }

  if ! $version {
    fail('Class[Elasticsearch_cgk]: parameter version must be provided')
  }

  case $enable {
    true, false: { $enable_real = $enable }
    default:     { fail('Class[elasticsearch_cgk]: parameter enable must be a boolean') }
  }

  case $service_state {
    'running', 'stopped': { $service_state_real = $service_state }
    default:     { fail('Class[elasticsearch_cgk]: parameter service_state must be running or stopped') }
  }

  case $::osfamily {
    'RedHat': {
      class { 'elasticsearch_cgk::package':
        version     => $version,
        versionlock => $versionlock
      }

      class { 'elasticsearch_cgk::config':
        cluster_name => $cluster_name,
        data_dir     => $data_dir,
        logs_dir     => $logs_dir
      }

      class { 'elasticsearch_cgk::service':
        ensure => $service_state_real,
        enable => $enable_real
      }

      Anchor['elasticsearch_cgk::begin'] -> Class['elasticsearch_cgk::package'] -> Class['elasticsearch_cgk::config'] ~> Class['elasticsearch_cgk::service'] -> Anchor['elasticsearch_cgk::end']
    }
    default: {
      fail("Class['elasticsearch']: osfamily ${::osfamily} is not supported")
    }
  }

}
