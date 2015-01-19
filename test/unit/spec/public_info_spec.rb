require_relative 'spec_helper'

describe 'platformstack::public_info' do
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

        it 'installs the rest-client gem' do
          expect(chef_run).to install_chef_gem('rest-client')
        end

        it 'creates the directory for ohai plugins' do
          expect(chef_run).to create_directory('/etc/chef/ohai_plugins')
        end

        it 'renders a ohai plugin plugin_info.rb' do
          expect(chef_run).to render_file('/etc/chef/ohai_plugins/public_info.rb').with_content(/public_info/)
        end

        it 'reloads ohai' do
          expect(chef_run).to reload_ohai('reload_pubinfo')
        end
      end
    end
  end
end
