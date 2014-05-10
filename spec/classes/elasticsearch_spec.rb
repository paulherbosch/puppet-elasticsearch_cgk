#!/usr/bin/env rspec

require 'spec_helper'

describe 'elasticsearch' do
  let (:facts) { {
      :osfamily => 'RedHat'
  } }

  it { should contain_class 'elasticsearch' }
end
