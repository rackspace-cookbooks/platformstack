#
# Cookbook Name:: platformstack (originally rackops_rolebook)
# Recipe:: ohai_plugins
#
# Populate public_info attributes via an ohai plugin
#
# Copyright 2014, Rackspace, US Inc.
#

# Load the ohai recipe to populate node['ohai']
include_recipe 'ohai'
include_recipe 'git'

# Fail in a slightly more descriptive manner than the directory block below
#  if the plugin directory is unset.
if node['ohai']['plugin_path'].nil?
  raise 'ERROR: Ohai plugin path not set'
end

# Ensure the plugin directory exists
directory node['ohai']['plugin_path'] do
  owner 'root'
  group 'root'
  mode  '0755'
  recursive true
end

git "#{Chef::Config['file_cache_path']}/ohai_plugins" do
  repository Platformstack.get_rackops_platformstack(node, 'ohai_plugins', 'repo')
  reference Platformstack.get_rackops_platformstack(node, 'ohai_plugins', 'ref')
  action :sync
end

# this will require two converges unless we wrap it in a ruby block since the
# call to Dir[] runs before the git resource above
ruby_block 'copy plugin files to ohai from git sync in file_cache_path' do
  block do
    Dir["#{Chef::Config['file_cache_path']}/ohai_plugins/plugins/*"].each do |plugin|
      f = Chef::Resource::RemoteFile.new("#{node['ohai']['plugin_path']}/#{File.basename(plugin)}", run_context)
      f.source "file://#{plugin}"
      f.owner 'root'
      f.group 'root'
      f.mode '0644'

      f.run_action(:create)
    end
  end
end

ohai 'reload' do
  action :reload
end
