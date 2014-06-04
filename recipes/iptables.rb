include_recipe 'rackspace_iptables'

# Rackspace Bastion access
add_iptables_rule('INPUT', '-s 72.3.128.84/32 -j ACCEPT', 500, 'Rackspace Bastion')
add_iptables_rule('INPUT', '-s 69.20.0.1/32 -j ACCEPT', 501, 'Rackspace Bastion')
add_iptables_rule('INPUT', '-s 50.57.22.125/32 -j ACCEPT', 502, 'Rackspace Bastion')
add_iptables_rule('INPUT', '-s 120.136.34.22/32 -j ACCEPT', 503, 'Rackspace Bastion')
add_iptables_rule('INPUT', '-s 212.100.225.49/32 -j ACCEPT', 504, 'Rackspace Bastion')
add_iptables_rule('INPUT', '-s 212.100.225.42/32 -j ACCEPT', 505, 'Rackspace Bastion')
add_iptables_rule('INPUT', '-s 119.9.4.2/32 -j ACCEPT', 506, 'Rackspace Bastion')
# Rackspace Cloud Monitoring
add_iptables_rule('INPUT', '-s 50.56.142.128/26 -j ACCEPT', 507, 'Rackspace Monitoring')
add_iptables_rule('INPUT', '-s 50.57.61.0/26 -j ACCEPT', 508, 'Rackspace Monitoring')
add_iptables_rule('INPUT', '-s 78.136.44.0/26 -j ACCEPT', 509, 'Rackspace Monitoring')
add_iptables_rule('INPUT', '-s 180.150.149.64/26 -j ACCEPT', 510, 'Rackspace Monitoring')
add_iptables_rule('INPUT', '-s 69.20.52.192/26 -j ACCEPT', 511, 'Rackspace Monitoring')
# Rackspace Support
add_iptables_rule('INPUT', '-s 50.56.230.0/24 -j ACCEPT', 512, 'Rackspace Support')
add_iptables_rule('INPUT', '-s 50.56.228.0/24 -j ACCEPT', 513, 'Rackspace Support')

# Return
add_iptables_rule('INPUT', '-i lo -j ACCEPT', 3, 'Loopback')
add_iptables_rule('INPUT', '-m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT', 2, 'Allow establihsed')
add_iptables_rule('INPUT', '-s 0.0.0.0/0 -j REJECT', 1, 'Drop not allowed')
