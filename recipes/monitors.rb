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

if node['platformstack']['cloud_monitoring']['enabled'] == true
  package 'rackspace-monitoring-agent'
  if node.key?('cloud')
    execute 'agent-setup-cloud' do
      command "rackspace-monitoring-agent --setup --username #{node['rackspace']['cloud_credentials']['username']} --apikey #{node['rackspace']['cloud_credentials']['api_key']}"
      action :run
      # the filesize is zero if the agent has not been configured
      only_if { File.size?('/etc/rackspace-monitoring-agent.cfg').nil? }
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
  cpu
  disk
  load
  memory
  network
)

yaml_monitors.each do |monitor|
  template "/etc/rackspace-monitoring-agent.conf.d/monitoring-#{monitor}.yaml" do
    cookbook node['platformstack']['cloud_monitoring'][monitor]['cookbook']
    source "monitoring-#{monitor}.erb"
    owner 'root'
    group 'root'
    mode '00644'
    variables(
      cookbook_name: cookbook_name
    )
    only_if { node['platformstack']['cloud_monitoring'][monitor]['disabled'] == false }
    notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
  end
end

# any custom monitors
node['platformstack']['cloud_monitoring']['custom_monitors']['name'].each do |monitor|
  monitor_source = node['platformstack']['cloud_monitoring']['custom_monitors'][monitor]['source']
  monitor_cookbook = node['platformstack']['cloud_monitoring']['custom_monitors'][monitor]['cookbook']
  monitor_variables = node['platformstack']['cloud_monitoring']['custom_monitors'][monitor]['variables']

  template "/etc/rackspace-monitoring-agent.conf.d/monitoring-#{monitor}.yaml" do
    cookbook monitor_cookbook
    source monitor_source
    owner 'root'
    group 'root'
    mode '00644'
    variables(monitor_variables)
    notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
  end
end

node['platformstack']['cloud_monitoring']['remote_http']['name'].each do |monitor|
  monitor_source = node['platformstack']['cloud_monitoring']['remote_http'][monitor]['source']
  monitor_cookbook = node['platformstack']['cloud_monitoring']['remote_http'][monitor]['cookbook']
  monitor_variables = node['platformstack']['cloud_monitoring']['remote_http'][monitor]['variables']

  template '/etc/rackspace-monitoring-agent.conf.d/monitoring-remote-http.yaml' do
    cookbook monitor_cookbook
    source monitor_source
    owner 'root'
    group 'root'
    mode '00644'
    variables(monitor_variables)
    notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
  end
end

unless node['platformstack']['cloud_monitoring']['service']['name'].empty?
  directory '/usr/lib/rackspace-monitoring-agent/plugins' do
    recursive true
    owner 'root'
    group 'root'
    mode '00755'
  end

  template '/usr/lib/rackspace-monitoring-agent/plugins/service_mon.sh' do
    cookbook node['platformstack']['cloud_monitoring']['service_mon']['cookbook']
    source 'service_mon.sh.erb'
    owner 'root'
    group 'root'
    mode '00755'
    variables(
      cookbook_name: cookbook_name
    )
  end
  node['platformstack']['cloud_monitoring']['service']['name'].each do |service_name|
    template "/etc/rackspace-monitoring-agent.conf.d/monitoring-service-#{service_name}.yaml" do
      cookbook node['platformstack']['cloud_monitoring']['service']['cookbook']
      source 'monitoring-service.erb'
      owner 'root'
      group 'root'
      mode '00644'
      variables(
        cookbook_name: cookbook_name,
        service_name: service_name
      )
      notifies 'restart', 'service[rackspace-monitoring-agent]', :delayed
      only_if { node['platformstack']['cloud_monitoring']['service']['disabled'] == false }
    end
  end
end

node['platformstack']['cloud_monitoring']['filesystem']['target'].each do |_disk, mount|
  template "/etc/rackspace-monitoring-agent.conf.d/monitoring-filesystem-#{mount.gsub('/', '_slash_')}.yaml" do
    cookbook node['platformstack']['cloud_monitoring']['filesystem']['cookbook']
    source 'monitoring-filesystem.erb'
    owner 'root'
    group 'root'
    mode '00644'
    variables(
      cookbook_name: cookbook_name,
      mount: mount
    )
    notifies 'restart', 'service[rackspace-monitoring-agent]', :delayed
    only_if { node['platformstack']['cloud_monitoring']['filesystem']['disabled'] == false }
  end
end

unless node['platformstack']['cloud_monitoring']['plugins'].empty?
  directory '/usr/lib/rackspace-monitoring-agent/plugins' do
    recursive true
    owner 'root'
    group 'root'
    mode '00755'
  end

  # Loop through each custom plugin in hash
  node['platformstack']['cloud_monitoring']['plugins'].each do |plugin_name, value|
    # helper variable
    plugin_hash = value

    remote_file "/usr/lib/rackspace-monitoring-agent/plugins/#{plugin_hash['details']['file']}" do
      source plugin_hash['file_url']
      owner 'root'
      group 'root'
      mode '0755'
    end

    template "/etc/rackspace-monitoring-agent.conf.d/monitoring-plugin-#{plugin_name}.yaml" do
      cookbook plugin_hash['cookbook']
      source 'monitoring-plugin.erb'
      owner 'root'
      group 'root'
      mode '00644'
      variables(
        cookbook_name: cookbook_name,
        plugin_check_label: plugin_hash['label'],
        plugin_check_disabled: plugin_hash['disabled'],
        plugin_check_period: plugin_hash['period'],
        plugin_check_timeout: plugin_hash['timeout'],
        plugin_details_file: plugin_hash['details']['file'],
        plugin_details_args: plugin_hash['details']['args'],
        plugin_details_timeout: plugin_hash['details']['timeout'],
        plugin_alarm_label: plugin_hash['alarm']['label'],
        plugin_alarm_notification_plan_id: plugin_hash['alarm']['notification_plan_id'],
        plugin_alarm_criteria: plugin_hash['alarm']['criteria']
      )
      notifies 'restart', 'service[rackspace-monitoring-agent]', :delayed
      only_if { plugin_hash['disabled'] == false }
    end
  end

end

service 'rackspace-monitoring-agent' do
  supports start: true, status: true, stop: true, restart: true
  action %w(enable start)
  only_if { node['platformstack']['cloud_monitoring']['enabled'] == true }
end
