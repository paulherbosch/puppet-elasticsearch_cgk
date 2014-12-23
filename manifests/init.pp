# Class: elasticsearch
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
class elasticsearch(
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

  anchor { 'elasticsearch::begin': }
  anchor { 'elasticsearch::end': }

  if ! $version {
    fail('Class[Elasticsearch]: parameter version must be provided')
  }

  case $enable {
    true, false: { $enable_real = $enable }
    default:     { fail('Class[elasticsearch]: parameter enable must be a boolean') }
  }

  case $service_state {
    'running', 'stopped': { $service_state_real = $service_state }
    default:     { fail('Class[elasticsearch]: parameter service_state must be running or stopped') }
  }

  case $::osfamily {
    'RedHat': {
      class { 'elasticsearch::package':
        version     => $version,
        versionlock => $versionlock
      }

      class { 'elasticsearch::config':
        cluster_name => $cluster_name,
        data_dir     => $data_dir,
        logs_dir     => $logs_dir
      }

      class { 'elasticsearch::service':
        ensure => $service_state_real,
        enable => $enable_real
      }

      Anchor['elasticsearch::begin'] -> Class['elasticsearch::package'] -> Class['elasticsearch::config'] ~> Class['elasticsearch::service'] -> Anchor['elasticsearch::end']
    }
    default: {
      fail("Class['elasticsearch']: osfamily ${::osfamily} is not supported")
    }
  }

}
