#
# Cookbook Name:: platformstack
# Recipe:: monitoring
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

case node['platform_family']
when 'debian'
  apt_repository 'monitoring' do
    uri "https://stable.packages.cloudmonitoring.rackspace.com/#{node['platform']}-#{node['lsb']['release']}-x86_64"
    distribution 'cloudmonitoring'
    components ['main']
    key 'https://monitoring.api.rackspacecloud.com/pki/agent/linux.asc'
    action :add
  end
when 'rhel'
  yum_repository 'monitoring' do
    description 'Rackspace Cloud Monitoring agent repo'
    baseurl "https://stable.packages.cloudmonitoring.rackspace.com/#{node['platform']}-#{node['platform_version'][0]}-x86_64"
    gpgkey "https://monitoring.api.rackspacecloud.com/pki/agent/#{node['platform']}-#{node['platform_version'][0]}.asc"
    enabled true
    gpgcheck true
    action :add
  end
end

if node['platformstack']['cloud_monitoring']['enabled'] == true && File.size?('/etc/rackspace-monitoring-agent.cfg').nil?
  package 'rackspace-monitoring-agent'
  if node.key?('cloud')
    execute 'agent-setup-cloud' do
      command "rackspace-monitoring-agent --setup --username #{node['rackspace']['cloud_credentials']['username']} --apikey #{node['rackspace']['cloud_credentials']['api_key']}"
      creates '/etc/rackspace-monitoring-agent.cfg'
      action 'nothing'
    end
  else
    execute 'agent-setup-hybrid' do
      command "rackspace-monitoring-agent --setup --username #{node['rackspace']['hybrid_credentials']['username']} --apikey #{node['rackspace']['hybrid_credentials']['api_key']}"
      creates '/etc/rackspace-monitoring-agent.cfg'
      action 'nothing'
    end
  end
end

directory 'rackspace-monitoring-agent-confd' do
  path '/etc/rackspace-monitoring-agent.conf.d'
  owner 'root'
  group 'root'
  mode 00755
end

yaml_monitors = %w(
  monitoring-cpu
  monitoring-disk
  monitoring-filesystem
  monitoring-load
  monitoring-mem
  monitoring-net
)

yaml_monitors.each do |monitor|
  template "/etc/rackspace-monitoring-agent.conf.d/#{monitor}.yaml" do
    cookbook 'platformstack'
    source "#{monitor}.erb"
    owner 'root'
    group 'root'
    mode '00644'
    variables(
      cookbook_name: cookbook_name
    )
    only_if { node['platformstack']['cloud_monitoring']['enabled'] == true }
    notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
  end
end

service 'rackspace-monitoring-agent' do
  supports start: true, status: true, stop: true, restart: true
  action %w(enable start)
  only_if { node['platformstack']['cloud_monitoring']['enabled'] == true }
end
