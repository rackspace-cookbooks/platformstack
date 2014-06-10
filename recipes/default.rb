include_recipe 'platformstack::iptables'
include_recipe 'platformstack::ntp'
include_recipe 'platformstack::openssh'
include_recipe 'platformstack::timezone'

if node['platformstack']['enable_postfix'] == true
  include_recipe 'postfix'
end
