# Encoding: utf-8

require_relative 'spec_helper'

# this will pass on templatestack, fail elsewhere, forcing you to
# write those chefspec tests you always were avoiding
describe 'platformstack::monitors' do
  before { stub_resources }
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(platform: platform, version: version) do |node|
            node_resources(node)
            node.set['platformstack']['cloud_monitoring']['enabled'] = true

            # add a custom monitor, then test for it below
            node.set['platformstack']['cloud_monitoring']['remote_http']['name'] = []
            node.set['platformstack']['cloud_monitoring']['remote_http']['chefspec-monitor']['source'] = 'monitoring-remote-http.yaml.erb'
            node.set['platformstack']['cloud_monitoring']['remote_http']['chefspec-monitor']['cookbook'] = 'chefspec_book'
            node.set['platformstack']['cloud_monitoring']['remote_http']['chefspec-monitor']['variables'] = {
              disabled: false,
              perioud: 60,
              timeout: 15,
              alarm: false,
              port: 80,
              uri: '/',
              name: 'chefspec_monitor'
            }
            node.set['platformstack']['cloud_monitoring']['custom_monitors']['name'] = []
            node.set['platformstack']['cloud_monitoring']['custom_monitors']['name'].push('chefspec-monitor')
            node.set['platformstack']['cloud_monitoring']['custom_monitors']['chefspec-monitor']['source'] = 'chefspec_monitor.yaml.erb'
            node.set['platformstack']['cloud_monitoring']['custom_monitors']['chefspec-monitor']['cookbook'] = 'chefspec_book'
            node.set['platformstack']['cloud_monitoring']['custom_monitors']['chefspec-monitor']['variables'] = { warning: 'foo' }
          end.converge(described_recipe)
        end

        _property = load_platform_properties(platform: platform, platform_version: version)

        it 'creates directories for monitoring agent and plugins' do
          expect(chef_run).to create_directory('/etc/rackspace-monitoring-agent.conf.d')
          expect(chef_run).to create_directory('/usr/lib/rackspace-monitoring-agent/plugins')
        end

        it 'creates templates for custom monitors' do
          expect(chef_run).to create_template('/etc/rackspace-monitoring-agent.conf.d/monitoring-chefspec-monitor.yaml')
        end

        it 'creates templates for specific monitors' do
          expect(chef_run).to create_template('/etc/rackspace-monitoring-agent.conf.d/monitoring-cpu.yaml')
          expect(chef_run).to create_template('/etc/rackspace-monitoring-agent.conf.d/monitoring-disk.yaml')
          expect(chef_run).to create_template('/etc/rackspace-monitoring-agent.conf.d/monitoring-load.yaml')
          expect(chef_run).to create_template('/etc/rackspace-monitoring-agent.conf.d/monitoring-memory.yaml')
          expect(chef_run).to create_template('/etc/rackspace-monitoring-agent.conf.d/monitoring-network.yaml')
          expect(chef_run).to create_template('/etc/rackspace-monitoring-agent.conf.d/monitoring-filesystem-_slash_.yaml')
          expect(chef_run).to create_template('/etc/rackspace-monitoring-agent.conf.d/monitoring-plugin-chef-client.yaml')

          if platform == 'ubuntu' && version == '12.04'
            expect(chef_run).to create_template('/etc/rackspace-monitoring-agent.conf.d/monitoring-filesystem-_slash_boot.yaml')
            expect(chef_run).to create_template('/etc/rackspace-monitoring-agent.conf.d/monitoring-filesystem-_slash_vagrant.yaml')
          end

          if platform == 'ubuntu' && version == '14.04'
            expect(chef_run).to create_template('/etc/rackspace-monitoring-agent.conf.d/monitoring-filesystem-_slash_sys_slash_fs_slash_pstore.yaml')
          end

          if platform == 'centos'
            expect(chef_run).to create_template('/etc/rackspace-monitoring-agent.conf.d/monitoring-filesystem-_slash_home.yaml')
          end
        end

        it 'adds a repository for monitoring' do
          expect(chef_run).to add_apt_repository('monitoring') if platform == 'ubuntu'
          expect(chef_run).to add_yum_repository('monitoring') if platform == 'centos'
        end

        it 'enables and starts monitoring agent' do
          expect(chef_run).to enable_service('rackspace-monitoring-agent')
          expect(chef_run).to start_service('rackspace-monitoring-agent')
        end

        it 'installs remote file for chef node checking monitoring' do
          expect(chef_run).to create_remote_file('/usr/lib/rackspace-monitoring-agent/plugins/chef_node_checkin.py')
        end

        it 'installs the monitoring agent package' do
          expect(chef_run).to install_package('rackspace-monitoring-agent')
        end
      end
    end
  end
end
