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
}

def node_resources(node)
  node.set['newrelic']['license'] = 'dummy_value'

  # need to stub this search that this causes, then set this to 'a,b,c'
  node.set['elasticsearch']['discovery']['zen']['ping']['unicast']['hosts'] = nil

  # don't want to do a huge stub for a unit test what amounts to a very simple include
  node.set['platformstack']['elkstack_logging']['enabled'] = false
end

def stub_resources
end

at_exit { ChefSpec::Coverage.report! }
