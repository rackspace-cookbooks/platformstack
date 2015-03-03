require_relative 'spec_helper'

describe 'platformstack::ohai_plugins' do
  before { stub_resources }
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform, version: version) do |node|
            node_resources(node)

            node.set['cpu']['total'] = 8
            node.set['public_info']['remote_ip'] = '127.0.0.1'
          end.converge(described_recipe)
        end

        # we can use anything here to test it later
        _property = load_platform_properties(platform: platform, platform_version: version)

        it 'creates /etc/chef/ohai_plugins' do
          expect(chef_run).to create_directory('/etc/chef/ohai_plugins')
        end

        it 'does a git sync' do
          expect(chef_run).to git_sync("#{Chef::Config[:file_cache_path]}/ohai_plugins")
        end

        it 'reloads ohai' do
          expect(chef_run).to reload_ohai(:reload)
        end
      end
    end
  end
end
