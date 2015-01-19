#
# Cookbook Name:: platformstack (originally rackops_rolebook)
# Recipe:: motd
#
# Copyright 2014, Rackspace, US Inc.
#

include_recipe 'motd-tail'

motd_tail '/etc/motd.tail' do
  template_source 'motd.erb'
end
