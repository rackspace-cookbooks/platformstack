# Encoding: utf-8
require 'rspec/expectations'
require 'chefspec'
require 'chefspec/berkshelf'
require 'chef/application'
require 'json'

Dir['./test/unit/spec/support/**/*.rb'].sort.each { |f| require f }

::LOG_LEVEL = :fatal
::CHEFSPEC_OPTS = {
  log_level: ::LOG_LEVEL
}.freeze

def node_resources(node)
  stub_search('node', 'role:loghost').and_return([])
  node.set['newrelic']['license'] = 'dummy_value'

  # need to stub this search that this causes, then set this to 'a,b,c'
  node.set['elasticsearch']['discovery']['zen']['ping']['unicast']['hosts'] = nil

  # chefspec can't handle the empty nested array
  node.default['platformstack']['cloud_monitoring']['custom_monitors']['name'] = []

  # disable consul
  node.set['platformstack']['consul']['enabled'] = false
end

def stub_resources
  stub_command('which sudo').and_return('/usr/bin/sudo')
  stub_command('test -L /usr/local/bin/consul').and_return(true)
  stub_command('/usr/bin/test /etc/alternatives/mta -ef /usr/sbin/sendmail.postfix').and_return(true)
end

at_exit { ChefSpec::Coverage.report! }
