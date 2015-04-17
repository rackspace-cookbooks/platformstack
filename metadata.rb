name 'platformstack'
maintainer 'Rackspace'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license 'Apache 2.0'
description 'Provides Rackspace base platform and managed support'

version '3.1.1'

%w(ubuntu debian redhat centos).each do |os|
  supports os
end

depends 'apt', '~> 2.6'
depends 'auto-patch'
depends 'chef-client'
depends 'chef-sugar'
depends 'client-rekey'
depends 'consul'
depends 'git'
depends 'java'
depends 'motd-tail', '~> 2.0'
depends 'newrelic'
depends 'ntp'
depends 'omnibus_updater'
depends 'ohai', '~> 2.0'
depends 'openssh'
depends 'postfix'
depends 'rackspace_cloudbackup'
depends 'rackspace_iptables', '~> 1.7'
depends 'rsyslog'
depends 'statsd'
depends 'sudo', '~> 2.7'
depends 'timezone-ii'
depends 'user', '~> 0.3'
depends 'yum'
depends 'slack_handler'

# conflicts with any version @ 2.0.0 of this cookbook
conflicts 'rackops_rolebook'
