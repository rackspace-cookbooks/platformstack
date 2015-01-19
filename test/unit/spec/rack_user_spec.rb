require_relative 'spec_helper'

describe 'platformstack::rack_user' do
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

        it 'includes sudo and user' do
          %w(sudo user).each do |recipe|
            expect(chef_run).to include_recipe(recipe)
          end
        end

        it 'downloads authorized_keys file' do
          expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/authorized_keys")
        end

        it 'adds rack user to sudo' do
          expect(chef_run).to install_sudo('rack')
        end
      end
    end
  end
end
