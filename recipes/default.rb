log 'run the default stuff last' do
  level :debug
  notifies :create, 'ruby_block[platformstack]', :delayed
end

ruby_block 'platformstack' do
  block do
    Chef::DSL::IncludeRecipe('platformstack::iptables')
    Chef::DSL::IncludeRecipe('platformstack::ntp')
    Chef::DSL::IncludeRecipe('platformstack::openssh')
    Chef::DSL::IncludeRecipe('platformstack::timezone')
    Chef::DSL::IncludeRecipe('platformstack::logstash_rsyslog')
  end
end
#include_recipe 'platformstack::iptables'
#include_recipe 'platformstack::ntp'
#include_recipe 'platformstack::openssh'
#include_recipe 'platformstack::timezone'
#include_recipe 'platformstack::logstash_rsyslog'
#include_recipe 'platformstack::monitors'
#include_recipe 'platformstack::newrelic'
