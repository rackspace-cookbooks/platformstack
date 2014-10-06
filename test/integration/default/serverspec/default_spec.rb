# Encoding: utf-8

require_relative 'spec_helper'

describe command('locale') do
  its(:exit_status) { should eq 0 }
  # its(:stdout) { should match(/en_US/) }
end

describe service('chef-client') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/cron.d/auto-patch') do
  it { should be_file }
end
