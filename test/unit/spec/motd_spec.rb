require_relative 'spec_helper'

describe 'platformstack::rackops_rolebook' do
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

        it 'includes motd-tail' do
          expect(chef_run).to include_recipe('motd-tail')
        end

        it 'create motd_tail resource' do
          expect(chef_run).to create_motd_tail('/etc/motd.tail')
        end
      end
    end
  end
end
