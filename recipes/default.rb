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

node.default['authorization']['sudo']['include_sudoers_d'] = true
node.default['chef-client']['log_file'] = '/var/log/chef/client.log'
node.default['apt']['compile_time_update'] = true

include_recipe 'apt::default'

log 'run the default stuff last' do
  level :debug
  notifies :create, 'ruby_block[platformstack]', :delayed
end

ruby_block 'platformstack' do
  block do
    run_context.include_recipe('platformstack::locale')
    run_context.include_recipe('ntp::default')
    run_context.include_recipe('platformstack::openssh')
    run_context.include_recipe('platformstack::timezone')
    run_context.include_recipe('platformstack::logstash_rsyslog')
    run_context.include_recipe('platformstack::patching')
    unless Chef::Config[:solo] == true
      run_context.include_recipe('chef-client::default')
      run_context.include_recipe('chef-client::delete_validation')
      run_context.include_recipe('chef-client::config')
    end
    if node['platformstack']['enable_postfix'] == true
      run_context.include_recipe('postfix::default')
    end
    unless node['newrelic']['license'].nil?
      run_context.include_recipe('platformstack::newrelic')
    end
    if node['rackspace']['cloudbackup']['enabled'] == true
      run_context.include_recipe('platformstack::monitors')
    end
    # run this last because if feels so good
    run_context.include_recipe('platformstack::iptables')
  end
end
