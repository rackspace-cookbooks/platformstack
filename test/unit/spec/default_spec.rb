# Encoding: utf-8

require_relative 'spec_helper'

# this will pass on templatestack, fail elsewhere, forcing you to
# write those chefspec tests you always were avoiding
describe 'platformstack::default' do
  before { stub_resources }
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        context 'when everything is enabled' do
          let(:chef_run) do
            # step_into the ruby block so we can test recipe includes
            ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['ruby_block']) do |node|
              node_resources(node)
              node.set['platformstack']['postfix']['enabled'] = true
              # Commented as it raises an error on Chefspec
              # node.set['platformstack']['cloud_backup']['enabled'] = true
              node.set['platformstack']['statsd']['enabled'] = true
              node.set['platformstack']['logstash_rsyslog']['enabled'] = true
              # rsyslog minimal configuration with chef-solo
              node.set['rsyslog']['server_ip'] = '10.0.0.1'
              # Commented as it raises an error on Chefspec(chef-solo)
              # node.set['platformstack']['client_rekey']['enabled'] = true
              node.set['platformstack']['slack_handler']['enabled'] = true
              node.set['platformstack']['omnibus_updater']['enabled'] = true
              node.set['platformstack']['consul']['enabled'] = false
              node.set['platformstack']['cloud_monitoring']['enabled'] = true
              node.set['platformstack']['iptables']['enabled'] = true
            end.converge(described_recipe)
          end

          # we can use anything here to test it later
          _property = load_platform_properties(platform: platform, platform_version: version)

          it 'includes the ruby block recipes' do
            %w(
              postfix
              statsd
              rsyslog::client
              slack_handler
              omnibus_updater
              platformstack::monitors
              platformstack::iptables
              openssh
            ).each do |recipe|
              expect(chef_run).to include_recipe(recipe)
            end
          end

          # don't include it if node['newrelic']['license'] not set
          it 'includes newrelic monitoring' do
            expect(chef_run).to include_recipe('newrelic::default')
          end

          it 'creates log resource to run default stuff last' do
            expect(chef_run).to write_log('run the default stuff last')
          end

          it 'creates ruby_block platformstack' do
            expect(chef_run).to run_ruby_block('platformstack')
          end
        end
        context 'when cloud monitoring disabled' do
          let(:chef_run) do
            # step_into the ruby block so we can test recipe includes
            ChefSpec::SoloRunner.new(platform: platform, version: version, step_into: ['ruby_block']) do |node|
              node_resources(node)
              # Manually disable cloud_monitoring
              node.set['platformstack']['cloud_monitoring']['enabled'] = false
            end.converge(described_recipe)
          end
          it "doesn't include cloud monitoring" do
            expect(chef_run).to_not include_recipe('platformstack::monitors')
          end
        end
      end
    end
  end
end
