#
# Cookbook Name:: platformstack
# Recipe:: default
#
# Author:: Matthew Thode <matt.thode@rackspace.com>
#
# Copyright 2014. Rackspace, US Inc.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'chef-sugar'

node.default['authorization']['sudo']['include_sudoers_d'] = true
node.default['chef-client']['log_file'] = '/var/log/chef/client.log'
node.default['apt']['compile_time_update'] = true
node.default['tz'] = 'Etc/UTC'

include_recipe 'apt::default' if platform_family?('debian')

log 'run the default stuff last' do
  level :debug
  notifies :create, 'ruby_block[platformstack]', :delayed
end

ruby_block 'platformstack' do # ~FC014
  block do
    run_context.include_recipe('platformstack::locale')
    run_context.include_recipe('ntp')
    run_context.include_recipe('timezone-ii') if node['platformstack']['timezone-ii']['enabled'] == true
    run_context.include_recipe('auto-patch')
    unless Chef::Config[:solo] == true
      run_context.include_recipe('chef-client::delete_validation')
      run_context.include_recipe('chef-client::config')
      run_context.include_recipe('chef-client')
    end
    run_context.include_recipe('postfix') if node['platformstack']['postfix']['enabled'] == true
    run_context.include_recipe('statsd') if node['platformstack']['statsd']['enabled'] == true
    run_context.include_recipe('rsyslog::client') if node['platformstack']['logstash_rsyslog']['enabled'] == true
    run_context.include_recipe('client-rekey') if node['platformstack']['client_rekey']['enabled'] == true
    run_context.include_recipe('slack_handler') if node['platformstack']['slack_handler']['enabled'] == true
    run_context.include_recipe('omnibus_updater') if node['platformstack']['omnibus_updater']['enabled'] == true
    run_context.include_recipe('consul::install_binary') if node['platformstack']['consul']['enabled'] == true
    run_context.include_recipe('platformstack::monitors') if node['platformstack']['cloud_monitoring']['enabled'] == true
    # run this last because if feels so good
    run_context.include_recipe('platformstack::iptables') if node['platformstack']['iptables']['enabled'] == true
    # down here because iptables sets an attribute for openssh if it's rackconnected
    run_context.include_recipe('openssh')
  end
end

include_recipe('rackspace_cloudbackup') if node['platformstack']['cloud_backup']['enabled'] == true
include_recipe('newrelic::default') if node.deep_fetch('newrelic', 'license') && !node.deep_fetch('newrelic', 'license').empty?
