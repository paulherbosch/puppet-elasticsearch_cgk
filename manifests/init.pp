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
  $version = 'present',
  $enable = true,
  $service_state = 'running'
) {

  anchor { 'elasticsearch::begin': }
  anchor { 'elasticsearch::end': }

  case $version {
    'present', 'latest': { $version_real = $version }
    default:             { fail('Class[elasticsearch]: parameter version must be present or latest') }
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
        version => $version_real
      }
      class { 'elasticsearch::config': }
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
