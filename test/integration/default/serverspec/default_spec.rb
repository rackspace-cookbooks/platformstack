# Encoding: utf-8

require_relative 'spec_helper'

describe command('locale | grep LANG=en_US.UTF-8') do
  it { should return_exit_status 0 }
end

describe service('chef-client') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/cron.d/auto-patch') do
  it { should be_file }
end
