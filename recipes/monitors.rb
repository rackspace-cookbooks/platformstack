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
    baseurl "https://stable.packages.cloudmonitoring.rackspace.com/#{node['platform']}-#{node['lsb']['release']}-x86_64"
    gpgkey "https://monitoring.api.rackspacecloud.com/pki/agent/#{node['platform']}-#{node['lsb']['release']}.asc"
    enabled true
    gpgcheck true
    action :add
  end
end

package 'rackspace-monitoring-agent' do
  action :upgrade
end
