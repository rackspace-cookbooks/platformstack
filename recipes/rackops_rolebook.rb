#
# Cookbook Name:: platformstack (originally rackops_rolebook)
# Recipe:: default
#
# Copyright 2014, Rackspace, US Inc.
#

include_recipe 'chef-sugar'

# run these rackops recipes, and default platformstack
critical_recipes = %w(
  motd
  rack_user
  ohai_plugins
  public_info
  default
)

# Run critical recipes
critical_recipes.each do |recipe|
  include_recipe "platformstack::#{recipe}"
end

if node['platformstack']['iptables']['enabled'] == true
  include_recipe 'platformstack::acl'
end

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
  git
)

case node['platform_family']
when 'debian'
  admin_packages.push('vim')
  admin_packages.push('tmux')
  admin_packages.push('htop') # htop not available in cent/rhel w/o epel
  node.override['apt']['compile_time_update'] = true
  include_recipe 'apt'
when 'rhel'
  admin_packages.push('vim-minimal')
end

admin_packages.each do |admin_package|
  package admin_package do
    action :install
  end
end

# Set the default editor based on attribute
template 'editor-env-var' do
  cookbook Platformstack.get_rackops_platformstack(node, 'templates', 'editor-env-var')
  source 'editor.sh.erb'
  path '/etc/profile.d/editor.sh'
  owner 'root'
  group 'root'
  mode '00755'
  variables(
    cookbook_name: cookbook_name
  )
end
