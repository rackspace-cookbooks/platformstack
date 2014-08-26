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

node['filesystem'].each do |key, data|
  next if data['percent_used'].nil? || data['fs_type'].nil?
  next if node['platformstack']['cloud_monitoring']['filesystem']['non_monitored_fstypes'].nil?
  next if node['platformstack']['cloud_monitoring']['filesystem']['non_monitored_fstypes'].include?(data['fs_type'])
  default['platformstack']['cloud_monitoring']['filesystem']['target'][key] = data['mount']
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

# Currently for service monitoring, the recipe that sets up the service should add:
# node.default['platformstack']['cloud_monitoring']['service']['name'].push('<service_name>')
default['platformstack']['cloud_monitoring']['service']['name']         = []
default['platformstack']['cloud_monitoring']['service']['disabled']     = false
default['platformstack']['cloud_monitoring']['service']['alarm']        = false
default['platformstack']['cloud_monitoring']['service']['period']       = 60
default['platformstack']['cloud_monitoring']['service']['timeout']      = 30
default['platformstack']['cloud_monitoring']['service']['cookbook'] = 'platformstack'
default['platformstack']['cloud_monitoring']['service_mon']['cookbook'] = 'platformstack'

default['platformstack']['cloud_monitoring']['plugins'] = {}
# Generic plugin support. Requires hash like:
# node['platformstack']['cloud_monitoring']['plugins']['plugin_name_here']['label'] = ''
# node['platformstack']['cloud_monitoring']['plugins']['plugin_name_here']['disabled'] = false
# node['platformstack']['cloud_monitoring']['plugins']['plugin_name_here']['period'] = 60
# node['platformstack']['cloud_monitoring']['plugins']['plugin_name_here']['timeout'] = 30
# node['platformstack']['cloud_monitoring']['plugins']['plugin_name_here']['file_url'] = ''
# node['platformstack']['cloud_monitoring']['plugins']['plugin_name_here']['cookbook'] = 'platformstack'
# node['platformstack']['cloud_monitoring']['plugins']['plugin_name_here']['details']['file'] = ''
# node['platformstack']['cloud_monitoring']['plugins']['plugin_name_here']['details']['args'] =[]
# node['platformstack']['cloud_monitoring']['plugins']['plugin_name_here']['details']['timeout'] = 60
# node['platformstack']['cloud_monitoring']['plugins']['plugin_name_here']['alarm']['label'] = ''
# node['platformstack']['cloud_monitoring']['plugins']['plugin_name_here']['alarm']['notification_plan_id'] = ''
# node['platformstack']['cloud_monitoring']['plugins']['plugin_name_here']['alarm']['criteria'] = ''

if node['rackspace']['cloud_credentials']['username'].nil? || node['rackspace']['cloud_credentials']['api_key'].nil?
  default['platformstack']['cloud_monitoring']['enabled'] = false
else
  default['platformstack']['cloud_monitoring']['enabled'] = true
end
default['platformstack']['cloud_monitoring']['notification_plan_id'] = 'npTechnicalContactsEmail'
