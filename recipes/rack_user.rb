#
# Cookbook Name:: platformstack (originally rackops_rolebook)
# Recipe:: user
#
# Copyright 2014, Rackspace, US Inc.
#

node.set['authorization']['sudo']['include_sudoers_d'] = true

include_recipe 'sudo'
include_recipe 'user'

# Have to disable FC009 because FC by default checks against chef 11.4 syntax
# You can run foodcritic with `-c 11.6.0` and see that this all passes.
remote_file "#{Chef::Config[:file_cache_path]}/authorized_keys" do # ~FC009
  source 'https://raw.github.com/rackops/authorized_keys/master/authorized_keys'
  owner 'root'
  group 'root'
  mode 0644
  use_conditional_get true
  use_etag true
  use_last_modified false
  notifies :create, 'ruby_block[put_auth_keys_into_array]', :immediately
end

ruby_block 'put_auth_keys_into_array' do
  block do
    key_array = []
    pattern = /^ssh-rsa/
    File.readlines("#{Chef::Config[:file_cache_path]}/authorized_keys").each do |line|
      if pattern =~ line
        key_array.push(line)
      end
    end
    ua = Chef::Resource::UserAccount.new('rack', run_context)
    ua.comment 'Rackspace User'
    ua.home '/home/rack'
    ua.ssh_keys key_array
    ua.run_action :create
  end
  action :nothing
end

sudo 'rack' do
  user 'rack'
  nopasswd true
end
