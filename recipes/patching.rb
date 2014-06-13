#
# Cookbook Name:: platformstack
# Recipe:: patching
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

node.default['auto-patch']['disable'] = false
node.default['auto-patch']['hour'] = 3
node.default['auto-patch']['minute'] = 0
node.default['auto-patch']['monthly'] = 'first sunday'
node.default['auto-patch']['reboot'] = false
node.default['auto-patch']['splay'] = 120
node.default['auto-patch']['weekly'] = "saturday"

node.default['auto-patch']['prep']['clean'] = true
node.default['auto-patch']['prep']['disable'] = true
node.default['auto-patch']['prep']['hour'] = 2
node.default['auto-patch']['prep']['minute'] = 0
node.default['auto-patch']['prep']['monthly'] = 'first sunday'
node.default['auto-patch']['prep']['splay'] = 1800
node.default['auto-patch']['prep']['weekly'] = nil
node.default['auto-patch']['prep']['update_updater'] = true

include_recipe 'auto-patch::default'
