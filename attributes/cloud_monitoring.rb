#
# Cookbook Name:: platformstack
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

warn_load_threshold = node['cpu']['total'] * 2
crit_load_threshold = node['cpu']['total'] * 3

default['platformstack']['cloud_monitoring']['cpu']['disabled'] = false
default['platformstack']['cloud_monitoring']['cpu']['alarm'] = false
default['platformstack']['cloud_monitoring']['cpu']['period'] = 90
default['platformstack']['cloud_monitoring']['cpu']['timeout'] = 30
default['platformstack']['cloud_monitoring']['cpu']['crit'] = 95
default['platformstack']['cloud_monitoring']['cpu']['warn'] = 90
default['platformstack']['cloud_monitoring']['cpu']['cookbook'] = 'platformstack'

default['platformstack']['cloud_monitoring']['disk']['disabled'] = false
default['platformstack']['cloud_monitoring']['disk']['alarm'] = false
default['platformstack']['cloud_monitoring']['disk']['target'] = '/dev/xvda1'
default['platformstack']['cloud_monitoring']['disk']['target_mountpoint'] = '/'
default['platformstack']['cloud_monitoring']['disk']['period'] = 60
default['platformstack']['cloud_monitoring']['disk']['timeout'] = 30
default['platformstack']['cloud_monitoring']['disk']['alarm_criteria'] = ''
default['platformstack']['cloud_monitoring']['disk']['cookbook'] = 'platformstack'

default['platformstack']['cloud_monitoring']['filesystem']['disabled'] = false
default['platformstack']['cloud_monitoring']['filesystem']['alarm'] = false
default['platformstack']['cloud_monitoring']['filesystem']['period'] = 60
default['platformstack']['cloud_monitoring']['filesystem']['timeout'] = 30
default['platformstack']['cloud_monitoring']['filesystem']['crit'] = 90
default['platformstack']['cloud_monitoring']['filesystem']['warn'] = 80
default['platformstack']['cloud_monitoring']['filesystem']['cookbook'] = 'platformstack'
default['platformstack']['cloud_monitoring']['filesystem']['non_monitored_fstypes'] = %(tmpfs devtmpfs devpts proc mqueue cgroup efivars sysfs sys securityfs configfs fusectl)

# during chefspec tests with fauxhai, node['filesystem'] might be nil
unless node['filesystem'].nil?
  node['filesystem'].each do |key, data|
    next if data['percent_used'].nil? || data['fs_type'].nil?
    next if node['platformstack']['cloud_monitoring']['filesystem']['non_monitored_fstypes'].nil?
    next if node['platformstack']['cloud_monitoring']['filesystem']['non_monitored_fstypes'].include?(data['fs_type'])
    default['platformstack']['cloud_monitoring']['filesystem']['target'][key] = data['mount']
  end
end

default['platformstack']['cloud_monitoring']['load']['disabled'] = false
default['platformstack']['cloud_monitoring']['load']['alarm'] = false
default['platformstack']['cloud_monitoring']['load']['period'] = 60
default['platformstack']['cloud_monitoring']['load']['timeout'] = 30
default['platformstack']['cloud_monitoring']['load']['crit'] = crit_load_threshold
default['platformstack']['cloud_monitoring']['load']['warn'] = warn_load_threshold
default['platformstack']['cloud_monitoring']['load']['cookbook'] = 'platformstack'

default['platformstack']['cloud_monitoring']['memory']['disabled'] = false
default['platformstack']['cloud_monitoring']['memory']['alarm'] = false
default['platformstack']['cloud_monitoring']['memory']['period'] = 60
default['platformstack']['cloud_monitoring']['memory']['timeout'] = 30
default['platformstack']['cloud_monitoring']['memory']['crit'] = 95
default['platformstack']['cloud_monitoring']['memory']['warn'] = 90
default['platformstack']['cloud_monitoring']['memory']['cookbook'] = 'platformstack'

default['platformstack']['cloud_monitoring']['network']['disabled'] = false
default['platformstack']['cloud_monitoring']['network']['alarm'] = false
default['platformstack']['cloud_monitoring']['network']['target'] = 'eth0'
default['platformstack']['cloud_monitoring']['network']['period'] = 60
default['platformstack']['cloud_monitoring']['network']['timeout'] = 30
default['platformstack']['cloud_monitoring']['network']['recv']['crit'] = '76000'
default['platformstack']['cloud_monitoring']['network']['recv']['warn'] = '56000'
default['platformstack']['cloud_monitoring']['network']['send']['crit'] = '76000'
default['platformstack']['cloud_monitoring']['network']['send']['warn'] = '56000'
default['platformstack']['cloud_monitoring']['network']['cookbook'] = 'platformstack'

# NOTE: this is for 'service monitoring' using service_mon.sh. go to the next section for arbitrary monitors.
# Currently for service monitoring, the recipe that sets up the service should add:
# node.default['platformstack']['cloud_monitoring']['service']['name'].push('<service_name>')
default['platformstack']['cloud_monitoring']['service']['name']         = []
default['platformstack']['cloud_monitoring']['service']['disabled']     = false
default['platformstack']['cloud_monitoring']['service']['alarm']        = false
default['platformstack']['cloud_monitoring']['service']['period']       = 60
default['platformstack']['cloud_monitoring']['service']['timeout']      = 30
default['platformstack']['cloud_monitoring']['service']['cookbook'] = 'platformstack'
default['platformstack']['cloud_monitoring']['service_mon']['cookbook'] = 'platformstack'

# Remote-http monitors.
default['platformstack']['cloud_monitoring']['remote_http']['name']     = []

# arbitrary / non-service-monitors data structure for any arbitrary template
default['platformstack']['cloud_monitoring']['custom_monitors']['name'] = []
# Currently for arbitrary monitoring, the recipe that sets up the monitor should add:
# node.default['platformstack']['cloud_monitoring']['custom_monitors']['name'].push('<service_name>')
# and then populate node['platformstack']['cloud_monitoring'][service_name][setting] with your values
# default['platformstack']['cloud_monitoring']['custom_monitors'][<name>]['source'] = 'my_monitor.yaml.erb'
# default['platformstack']['cloud_monitoring']['custom_monitors'][<name>]['cookbook'] = 'your_cookbook'
# default['platformstack']['cloud_monitoring']['custom_monitors'][<name>]['variables'] = { :warning => 'foo' }

default['platformstack']['cloud_monitoring']['plugins'] = {}
# Generic plugin support. Requires hash like:
default['platformstack']['cloud_monitoring']['plugins']['chef-client']['label'] = 'chef-client'
default['platformstack']['cloud_monitoring']['plugins']['chef-client']['disabled'] = false
default['platformstack']['cloud_monitoring']['plugins']['chef-client']['period'] = 60
default['platformstack']['cloud_monitoring']['plugins']['chef-client']['timeout'] = 30
default['platformstack']['cloud_monitoring']['plugins']['chef-client']['file_url'] = 'https://raw.githubusercontent.com/racker/rackspace-monitoring-agent-plugins-contrib/master/chef_node_checkin.py'
default['platformstack']['cloud_monitoring']['plugins']['chef-client']['cookbook'] = 'platformstack'
default['platformstack']['cloud_monitoring']['plugins']['chef-client']['details']['file'] = 'chef_node_checkin.py'
default['platformstack']['cloud_monitoring']['plugins']['chef-client']['details']['args'] = []
default['platformstack']['cloud_monitoring']['plugins']['chef-client']['details']['timeout'] = 60
default['platformstack']['cloud_monitoring']['plugins']['chef-client']['alarm']['label'] = ''
default['platformstack']['cloud_monitoring']['plugins']['chef-client']['alarm']['notification_plan_id'] = 'npMANAGED'
default['platformstack']['cloud_monitoring']['plugins']['chef-client']['alarm']['criteria'] = ''

default['platformstack']['cloud_monitoring']['enabled'] = if node['rackspace']['cloud_credentials']['username'].nil? || node['rackspace']['cloud_credentials']['api_key'].nil?
                                                            false
                                                          else
                                                            true
                                                          end
default['platformstack']['cloud_monitoring']['notification_plan_id'] = 'npTechnicalContactsEmail'
