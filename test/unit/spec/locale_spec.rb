# Encoding: utf-8

require_relative 'spec_helper'

# this will pass on templatestack, fail elsewhere, forcing you to
# write those chefspec tests you always were avoiding
describe 'platformstack::locale' do
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

        it 'sets the appropriate locale' do
          # ubuntu
          expect(chef_run).to run_execute('/usr/sbin/update-locale LANG=en_US.UTF-8') if platform == 'ubuntu'

          # centos
          expect(chef_run).to render_file('/etc/sysconfig/i18n').with_content('.*LANG=en_US.UTF-8.*') if platform == 'rhel'
        end
      end
    end
  end

  # ensure it doesn't run with lxc?
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(platform: platform, version: version) do |node|
            node_resources(node)
            node.set['virtualization']['system'] = 'lxc'
          end.converge(described_recipe)
        end

        _property = load_platform_properties(platform: platform, platform_version: version)

        it 'does NOT set the appropriate locale under lxc' do
          # ubuntu
          expect(chef_run).to_not run_execute('/usr/sbin/update-locale LANG=en_US.UTF-8') if platform == 'ubuntu'

          # centos
          expect(chef_run).to_not render_file('/etc/sysconfig/i18n').with_content('.*LANG=en_US.UTF-8.*') if platform == 'rhel'
        end
      end
    end
  end
end
