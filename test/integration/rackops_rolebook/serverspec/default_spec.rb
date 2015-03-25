# Encoding: utf-8
require_relative 'spec_helper'

admin_packages = %w(
  sysstat
  dstat
  screen
  curl
  telnet
  traceroute
  mtr
  zip
  lsof
  strace
)

case os[:family]  # redHat, ubuntu, debian and so on
when 'redhat'
  admin_packages << 'vim-minimal'
when 'ubuntu'
  admin_packages << 'htop'
  admin_packages << 'vim'
end

admin_packages.each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe file('/etc/profile.d/editor.sh') do
  case os[:family]  # redHat, ubuntu, debian and so on
  when 'redhat'
    editor = 'vi'
  when 'ubuntu'
    editor = 'vim'
  else
    editor = 'fail'
  end

  its(:content) { should match(editor) }
end

# platformstack::motd
describe file('/etc/motd.tail') do
  its(:content) { should match(/This file is managed by Chef. Manual changes will be overridden/) }
end

# platformstack::rack_user
describe user('rack') do
  it { should exist }
end
describe file('/home/rack/.ssh/authorized_keys') do
  its(:content) { should match(/Generated by Chef/) }
  its(:content) { should match(/ssh-rsa/) }
  its(:content) { should match(/rackspace.com/) }
end
describe file('/etc/sudoers.d/rack') do
  its(:content) { should match(/This file is managed by Chef/) }
  its(:content) { should match(/rack ALL=\(ALL\) NOPASSWD:ALL/) }
end

# platformstack::ohai_plugins
# platformstack::public_info
describe command('which ohai') do
  its(:stdout) { should match(%r{/usr/bin/ohai}) }
end
describe command('which git') do
  its(:stdout) { should match(%r{/usr/bin/git}) }
end
describe file('/etc/chef/ohai_plugins/filesystem.rb') do # arbitrary choice
  its(:content) { should match(/FilesystemInodes/) }
end
describe file('/etc/chef/ohai_plugins/public_info.rb') do
  its(:content) { should match(/Publicinfo/) }
end
describe command('ohai -d /etc/chef/ohai_plugins/') do
  its(:stdout) { should match(/"public_info":/) }
end

# platformstack::acl
iptables_input_chain = %w(
  Support
  Monitoring
  Bastion
  Loopback
  ESTABLISHED
  secure-bastion
)
describe command('iptables -L') do
  iptables_input_chain.each do |txt|
    its(:stdout) { should match(txt) }
  end
end

# No need to test platformstack::default