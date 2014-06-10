node.default['authorization']['sudo']['include_sudoers_d'] = true
node.default['chef-client']['log_file'] = '/var/log/chef/client.log'

if node['platformstack']['enable_postfix'] == true
  include_recipe 'postfix'
end

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
    unless node['newrelic']['license'].nil?
      run_context.include_recipe('platformstack::newrelic')
    end
    if node['platformstack']['rackops']['enabled'] == true
      run_context.include_recipe('motd-tail::default')
      run_context.include_recipe('ohai::default')
      run_context.include_recipe('sudo::default')
      run_context.include_recipe('user::default')
      run_context.include_recipe('platformstack::rackops')
    end
    # run this last because if feels so good
    run_context.include_recipe('platformstack::iptables')
  end
end
