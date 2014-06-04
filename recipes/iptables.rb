include_recipe 'rackspace_iptables'

if node['platformstack']['iptables']['allow_ssh_from_world'] == true
  add_iptables_rule('INPUT', '-m tcp -p tcp --dport 22 -j ACCEPT', 9999, 'Allow ssh from the world')
end

# Return
add_iptables_rule('INPUT', '-i lo -j ACCEPT', 3, 'Loopback')
add_iptables_rule('INPUT', '-m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT', 2, 'Allow establihsed')
add_iptables_rule('INPUT', '-s 0.0.0.0/0 -j REJECT', 1, 'Drop not allowed')
