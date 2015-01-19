#
# Author:: Ryan Richard (ryan.richard@rackspace.com)
# Cookbook Name:: platformstack (originally rackops_rolebook)
# Recipe:: acl
#
# Copyright 2014, Rackspace US, Inc.
#

# Rackspace Bastion access
add_iptables_rule('INPUT', '-s 72.3.128.84/32 -j ACCEPT', 500, 'Bastion')
add_iptables_rule('INPUT', '-s 69.20.0.1/32 -j ACCEPT', 501, 'Bastion')
add_iptables_rule('INPUT', '-s 50.57.22.125/32 -j ACCEPT', 502, 'Bastion')
add_iptables_rule('INPUT', '-s 120.136.34.22/32 -j ACCEPT', 503, 'Bastion')
add_iptables_rule('INPUT', '-s 212.100.225.49/32 -j ACCEPT', 504, 'Bastion')
add_iptables_rule('INPUT', '-s 212.100.225.42/32 -j ACCEPT', 505, 'Bastion')
add_iptables_rule('INPUT', '-s 119.9.4.2/32 -j ACCEPT', 506, 'Bastion')

# Rackspace Cloud Monitoring
add_iptables_rule('INPUT', '-s 50.56.142.128/26 -j ACCEPT', 507, 'Monitoring')
add_iptables_rule('INPUT', '-s 50.57.61.0/26 -j ACCEPT', 508, 'Monitoring')
add_iptables_rule('INPUT', '-s 78.136.44.0/26 -j ACCEPT', 509, 'Monitoring')
add_iptables_rule('INPUT', '-s 180.150.149.64/26 -j ACCEPT', 510, 'Monitoring')
add_iptables_rule('INPUT', '-s 69.20.52.192/26 -j ACCEPT', 511, 'Monitoring')
add_iptables_rule('INPUT', '-s 92.52.126.0/24 -j ACCEPT', 512, 'Monitoring')

# Rackspace Support
add_iptables_rule('INPUT', '-s 50.56.230.0/24 -j ACCEPT', 513, 'Support')
add_iptables_rule('INPUT', '-s 50.56.228.0/24 -j ACCEPT', 514, 'Support')

# Return
add_iptables_rule('INPUT', '-i lo -j ACCEPT', 3, 'Loopback')
add_iptables_rule('INPUT', '-m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT', 2, 'Allow established')
add_iptables_rule('INPUT', '-s 0.0.0.0/0 -j REJECT', 1, 'Drop not allowed')
