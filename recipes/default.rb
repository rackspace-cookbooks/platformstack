include_recipe 'platformstack::iptables'
include_recipe 'platformstack::ntp'
include_recipe 'platformstack::openssh'
include_recipe 'platformstack::timezone'

if node['platformstack']['enable_postfix'] == true
  include_recipe 'postfix'
end

log 'run the default stuff last' do
  level :debug
  notifies :create, 'ruby_block[platformstack]', :delayed
end

ruby_block 'platformstack' do
  block do
    run_context.include_recipe('platformstack::iptables')
#                              'platformstack::ntp',
#                              'platformstack::openssh',
#                              'platformstack::timezone',
#                              'platformstack::logstash_rsyslog',
#                              'platformstack::monitors',
#                              'platformstack::newrelic'])
    run_context.include_recipe('platformstack::ntp')
    run_context.include_recipe('platformstack::openssh')
    run_context.include_recipe('platformstack::timezone')
    run_context.include_recipe('platformstack::logstash_rsyslog')
    run_context.include_recipe('platformstack::monitors')
    unless node['newrelic']['license'].nil?
      run_context.include_recipe('platformstack::newrelic')
    end
  end
end
