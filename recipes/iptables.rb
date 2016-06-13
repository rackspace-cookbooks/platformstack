#
# Cookbook Name:: platformstack
# Recipe:: iptables
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

unless lxc?
  if node['platformstack']['rackconnect'] == true
    sudo 'rackconnect' do
      user 'rackconnect'
      nopasswd true
    end
    node.default['openssh']['server']['password_authentication'] = 'yes'
  else
    include_recipe 'rackspace_iptables::default'

    ssh_port = if node['openssh']['server'].attribute?('port')
                 node['openssh']['server']['port']
               else
                 '22'
               end

    if node['platformstack']['iptables']['allow_ssh_from_world'] == true
      add_iptables_rule('INPUT', "-m tcp -p tcp --dport #{ssh_port} -j ACCEPT", 9999, 'Allow ssh from the world')
    end

    add_iptables_rule('INPUT', '-i lo -j ACCEPT', 3, 'Loopback')
    add_iptables_rule('INPUT', '-m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT', 2, 'Allow establihsed')
    add_iptables_rule('INPUT', '-s 0.0.0.0/0 -j REJECT', 1, 'Drop not allowed')
  end
end
