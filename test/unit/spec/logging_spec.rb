# Encoding: utf-8

require_relative 'spec_helper'

describe 'platformstack::logging' do
  before { stub_resources }
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(platform: platform, version: version) do |node|
            node_resources(node)
          end.converge(described_recipe)
        end

        _property = load_platform_properties(platform: platform, platform_version: version)

        # not sure we can test much else here
        it 'includes chef-sugar' do
          expect(chef_run).to include_recipe('chef-sugar::default')
        end
      end
    end
  end
end
