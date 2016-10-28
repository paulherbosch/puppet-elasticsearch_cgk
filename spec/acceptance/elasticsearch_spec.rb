require 'spec_helper_acceptance'

describe 'elasticsearch' do
  describe 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS
        include yum
        include stdlib
        include sunjdk
        include stdlib::stages
        include profile::package_management

        class { 'cegekarepos' : stage => 'setup_repo' }

        Yum::Repo <| title == 'custom' |>
        Yum::Repo <| title == 'custom-noarch' |>
        Yum::Repo <| title == 'cegeka-unsigned' |>
        Yum::Repo <| title == 'elasticsearch-1_4' |>

        file { '/data':
          ensure => directory,
          mode   => '0755'
        }

        file { '/data/logs/':
          ensure => directory,
          mode   => '0755'
        }

        sunjdk::instance { 'jdk.1.7.0_06-fcs':
          ensure      => 'present',
          jdk_version => '1.7.0_06-fcs',
          versionlock => true
        }

        class { 'elasticsearch':
          version           => '1.4.0-1',
          versionlock       => true,
          cluster_name      => 'spec-tests',
          heap_size         => '1g',
          mlock             => 'true'
        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
    describe port(9300) do
      it { should be_listening }
    end
  end
end
