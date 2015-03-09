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

default['openssh']['server']
default['openssh']['server']['ignore_rhosts'] = 'yes'
default['openssh']['server']['rhosts_r_s_a_authentication'] = 'no'
default['openssh']['server']['host_based_authentication'] = 'no'
default['openssh']['server']['permit_empty_passwords'] = 'no'
default['openssh']['server']['use_p_a_m'] = 'yes'
default['openssh']['server']['use_privilege_separation'] = 'yes'
default['openssh']['server']['protocol'] = '2'
default['openssh']['server']['x11_forwarding'] = 'no'
default['openssh']['server']['strict_modes'] = 'yes'
default['openssh']['server']['permit_root_login'] = 'no'
default['openssh']['server']['password_authentication'] = 'no'
default['openssh']['server']['challenge_response_authentication'] = 'no'
default['openssh']['server']['allow_tcp_forwarding'] = 'no'
default['openssh']['server']['use_privilege_separation'] = 'yes'

case node['platform_family']
when 'rhel', 'fedora'
  default['openssh']['server']['subsystem'] = 'sftp /usr/libexec/openssh/sftp-server'
when 'debian'
  default['openssh']['server']['subsystem'] = 'sftp  /usr/lib/openssh/sftp-server'
else
  default['openssh']['server']['subsystem'] = 'sftp   /usr/libexec/sftp-server'
end
