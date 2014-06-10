case node['platform_family']
when 'debian'
  apt_repository 'monitoring' do
    uri 'https://stable.packages.cloudmonitoring.rackspace.com'
    distribution "#{node['platform']}-#{node['lsb']['codename']}-x86_64"
    components ['main']
    keyserver 'keyserver.ubuntu.com'
    key 'D05AB914'
    action :create
  end
when 'rhel'
  yum_repository 'monitoring' do
    description 'Rackspace Cloud Monitoring agent repo'
    baseurl "https://stable.packages.cloudmonitoring.rackspace.com/#{node['platform']}-#{node['lsb']['release']}-x86_64"
    gpgkey "https://monitoring.api.rackspacecloud.com/pki/agent/#{node['platform']}-#{node['lsb']['release']}.asc"
    enabled true
    gpgcheck true
    action :create
  end
end

package 'rackspace-monitoring-agent' do
  action :upgrade
end
