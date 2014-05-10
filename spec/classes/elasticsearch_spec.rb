#!/usr/bin/env rspec

require 'spec_helper'

describe 'elasticsearch' do
  it { should contain_class 'elasticsearch' }
end
