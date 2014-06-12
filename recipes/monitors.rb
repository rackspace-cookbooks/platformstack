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

package 'rackspace-monitoring-agent' do
  action :upgrade
end

if ['platformstack']['cloud_monitoring']['enabled'] == true
  execute 'agent-setup' do
    command "rackspace-monitoring-agent --setup --username #{node['rackspace']['cloud_credentials']['username']} --apikey #{node['rackspace']['cloud_credentials']['api_key']}"
    creates '/etc/rackspace-monitoring-agent.cfg'
    action :run
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
    notifies 'restart', 'service[rackspace-monitoring-agent]', 'delayed'
  end
end

service 'rackspace-monitoring-agent' do
  supports start: true, status: true, stop: true, restart: true
  action %w(enable start)
end
