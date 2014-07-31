#!/usr/bin/env rspec

require 'spec_helper'

describe 'elasticsearch' do
  let (:facts) { {
      :osfamily => 'RedHat'
  } }

  let (:params) { {
    :version => '1.1.1-1'
  } }

  it { should contain_class 'elasticsearch' }
end
