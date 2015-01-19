name 'platformstack'
maintainer 'Rackspace'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license 'Apache 2.0'
description 'Provides Rackspace base platform and managed support'

version '2.0.0'

%w(ubuntu debian redhat centos).each do |os|
  supports os
end

depends 'auto-patch'
depends 'chef-client'
depends 'client-rekey'
depends 'consul'
depends 'newrelic'
depends 'ntp'
depends 'omnibus_updater'
depends 'openssh'
depends 'postfix'
depends 'rackspace_cloudbackup'
depends 'rsyslog'
depends 'statsd'
depends 'timezone-ii'
depends 'yum'
depends 'elkstack'
depends 'elasticsearch'
depends 'java'

depends 'apt', '~> 2.6'
depends 'git'
depends 'motd-tail', '~> 2.0'
depends 'ohai', '~> 2.0'
depends 'rackspace_iptables', '~> 1.7'
depends 'sudo', '~> 2.7'
depends 'user', '~> 0.3'
depends 'chef-sugar'

# conflicts with any version @ 2.0.0 of this cookbook
conflicts 'rackops_rolebook'
