# Rackspace Bastion access
add_iptables_rule('INPUT', '-s 72.3.128.84/32 -j ACCEPT', 500, 'Bastion')
add_iptables_rule('INPUT', '-s 69.20.0.1/32 -j ACCEPT', 501, 'Bastion')
add_iptables_rule('INPUT', '-s 50.57.22.125/32 -j ACCEPT', 502, 'Bastion')
add_iptables_rule('INPUT', '-s 120.136.34.22/32 -j ACCEPT', 503, 'Bastion')
add_iptables_rule('INPUT', '-s 212.100.225.49/32 -j ACCEPT', 504, 'Bastion')
add_iptables_rule('INPUT', '-s 212.100.225.42/32 -j ACCEPT', 505, 'Bastion')
add_iptables_rule('INPUT', '-s 119.9.4.2/32 -j ACCEPT', 506, 'Bastion')
# Rackspace Cloud Monitoring
add_iptables_rule('INPUT', '-s 50.56.142.128/26 -j ACCEPT', 507, 'Monitoring')
add_iptables_rule('INPUT', '-s 50.57.61.0/26 -j ACCEPT', 508, 'Monitoring')
add_iptables_rule('INPUT', '-s 78.136.44.0/26 -j ACCEPT', 509, 'Monitoring')
add_iptables_rule('INPUT', '-s 180.150.149.64/26 -j ACCEPT', 510, 'Monitoring')
add_iptables_rule('INPUT', '-s 69.20.52.192/26 -j ACCEPT', 511, 'Monitoring')
# Rackspace Support
add_iptables_rule('INPUT', '-s 50.56.230.0/24 -j ACCEPT', 512, 'Support')
add_iptables_rule('INPUT', '-s 50.56.228.0/24 -j ACCEPT', 513, 'Support')


# motd
motd_tail '/etc/motd' do
  template_source 'motd.erb'
end


# Fail in a slightly more descriptive manner than the directory block below
# if the plugin directory is unset.
if node['ohai']['plugin_path'].nil?
  fail 'ERROR: Ohai plugin path not set'
end
plugin_directory = directory node['ohai']['plugin_path'] do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
end
plugin_install = cookbook_file "#{node['ohai']['plugin_path']}/public_info.rb" do
  action :create
  owner 'root'
  group 'root'
  mode '0644'
end
reload_ohai = ohai 'reload' do
  action :nothing
end
# Run during compile, not convergance
plugin_directory.run_action(:create)
plugin_install.run_action(:create)
reload_ohai.run_action(:reload)
# Stop the run if the IP is invalid, assume failure here is preferable to running with invalid data
# This check is also important for testing: if the plugin fails to load and operate this exception will
# halt convergance breaking Kitchen runs.
unless node['public_info']['remote_ip'] =~ /[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/
  fail "ERROR: Unable to determine server remote IP. (Got \"#{node['public_info']['remote_ip']}\") Halting to avoid use of bad data."
end
# Assign the external_ip tag to the node if node['public_info']['remote_ip'] looks like an IP.
tag("RemoteIP:#{node['public_info']['remote_ip']}")


# rackspace user
user_account 'rack' do
  comment 'Rackspace User'
  home '/home/rack'
end
remote_file '/home/rack/.ssh/authorized_keys' do
  source 'https://raw.github.com/rackops/authorized_keys/master/authorized_keys'
  owner 'rack'
  group 'rack'
  mode 0644
end
sudo 'rack' do
  user 'rack'
  nopasswd true
end


# install packages
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
)
case node['platform_family']
when 'debian'
  admin_packages.push('vim')
  admin_packages.push('htop') # htop not available in cent/rhel w/o epel
  node.override['apt']['compile_time_update'] = true
  include_recipe 'apt'
when 'rhel'
  admin_packages.push('vim-minimal')
end
admin_packages.each do | admin_package |
  package admin_package do
    action :install
  end
end


# Set the default editor based on attribute
template 'editor-env-var' do
  cookbook node['platformstack']['rackops']['templates']['editor-env-var']
  source 'editor.sh.erb'
  path '/etc/profile.d/editor.sh'
  owner 'root'
  group 'root'
  mode '00755'
  variables(
    cookbook_name: cookbook_name
  )
end
