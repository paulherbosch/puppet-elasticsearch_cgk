#!/usr/bin/env rspec

require 'spec_helper'

describe 'elasticsearch_cgk' do
  let (:facts) { {
      :osfamily => 'RedHat'
  } }

  let (:params) { {
    :version => '1.1.1-1'
  } }

  it { should contain_class 'elasticsearch_cgk' }
end
