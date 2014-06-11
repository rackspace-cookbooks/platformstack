node.default['authorization']['sudo']['include_sudoers_d'] = true
node.default['chef-client']['log_file'] = '/var/log/chef/client.log'

log 'run the default stuff last' do
  level :debug
  notifies :create, 'ruby_block[platformstack]', :delayed
end

ruby_block 'platformstack' do
  block do
    run_context.include_recipe('platformstack::ntp')
    run_context.include_recipe('platformstack::openssh')
    run_context.include_recipe('platformstack::timezone')
    run_context.include_recipe('platformstack::logstash_rsyslog')
    run_context.include_recipe('platformstack::monitors')
    if node['platformstack']['enable_postfix'] == true
      run_context.include_recipe('postfix::default')
    unless node['newrelic']['license'].nil?
      run_context.include_recipe('platformstack::newrelic')
    end
    # run this last because if feels so good
    run_context.include_recipe('platformstack::iptables')
  end
end
