log 'run the default stuff last' do
  level :debug
  notifies :create, 'rubt_block[platformstack]', :delayed
end

ruby_block 'platformstack' do
  block do
    include_recipe 'platformstack::iptables'
    include_recipe 'platformstack::ntp'
    include_recipe 'platformstack::openssh'
    include_recipe 'platformstack::timezone'
  end
  action :create
end
