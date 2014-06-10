log 'run the default stuff last' do
  level :debug
#  notifies :create, 'ruby_block[platformstack]', :delayed
end

include_recipe 'platformstack::iptables'
include_recipe 'platformstack::ntp'
include_recipe 'platformstack::openssh'
include_recipe 'platformstack::timezone'
