apt_repository 'monitoring' do
  uri 'http://stable.packages.cloudmonitoring.rackspace.com'
  distribution "#{node['lsb']['release']}-#{node['lsb']['codename']}-x86_64"
  components ['main']
  keyserver 'keyserver.ubuntu.com'
  key 'D05AB914'
end

package 'rackspace-monitoring-agent' do
  action :upgrade
end
