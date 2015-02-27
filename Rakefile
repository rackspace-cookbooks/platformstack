# encoding: UTF-8
require 'foodcritic'
require 'kitchen'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

# Style tests. Rubocop and Foodcritic
namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = { search_gems: true,
                  tags: %w(~rackspace-support),
                  fail_tags: %w(correctness,rackspace)
                }
  end
end

desc 'Run all style checks'
task style: %w(style:chef style:ruby)

# Rspec and ChefSpec
namespace :unit do
  task :spec do
    RSpec::Core::RakeTask.new(:spec) do |t|
      t.rspec_opts = 'test/unit'
    end
  end
end
desc 'Run ChefSpec unit tests'
task spec: %w(unit:spec)

# Integration tests with kitchen.ci
desc 'Run Test Kitchen'
namespace :integration do
  Kitchen.logger = Kitchen.default_file_logger
  desc 'Run kitchen test with Vagrant'
  task :vagrant do
    Kitchen::Config.new.instances.each do |instance|
      instance.test(:always)
    end
  end

  %w(verify destroy).each do |t|
    desc "Run kitchen #{t} with cloud plugins"
    namespace :cloud do
      task t do
        @loader = Kitchen::Loader::YAML.new(local_config: '.kitchen.cloud.yml')
        config = Kitchen::Config.new(loader: @loader)
        concurrency = config.instances.size
        queue = Queue.new
        config.instances.each { |i| queue << i }
        concurrency.times { queue << nil }
        threads = []
        concurrency.times do
          threads << Thread.new do
            while instance = queue.pop
              instance.send(t)
            end
          end
        end
        threads.map(&:join)
      end
    end
  end

  desc 'Run all kitchen tasks with cloud plugins'
  task cloud: %w(cloud:verify cloud:destroy)
end

desc 'Run all tests on a CI Platform'
task ci: %w(style spec integration:cloud)

# Default
task default: %w(style spec integration:vagrant)
