# Encoding: utf-8

require_relative 'spec_helper'

# this will pass on templatestack, fail elsewhere, forcing you to
# write those chefspec tests you always were avoiding
describe 'platformstack::iptables' do
  before { stub_resources }

  # rackconnect
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform, version: version) do |node|
            node_resources(node)
            node.set['platformstack']['rackconnect'] = true
          end.converge(described_recipe)
        end

        _property = load_platform_properties(platform: platform, platform_version: version)

        it 'allows sudo for the rackconnect user' do
          expect(chef_run).to install_sudo('rackconnect')
        end
      end
    end
  end

  # regular iptables
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(platform: platform, version: version) do |node|
            node_resources(node)
            node.set['platformstack']['rackconnect'] = false
          end.converge(described_recipe)
        end

        _property = load_platform_properties(platform: platform, platform_version: version)

        it 'includes rackspace_iptables' do
          expect(chef_run).to include_recipe('rackspace_iptables::default')
        end
      end
    end
  end
end
