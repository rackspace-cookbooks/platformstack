name 'platformstack'
maintainer 'Rackspace'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license 'Apache 2.0'
description 'Provides Rackspace managed support beyond rackops_rolebook'

version '1.5.0'

%w(ubuntu debian redhat centos).each do |os|
  supports os
end

depends 'apt'
depends 'auto-patch'
depends 'chef-client'
depends 'chef-sugar'
depends 'client-rekey'
depends 'consul'
depends 'newrelic'
depends 'motd-tail'
depends 'ntp'
depends 'ohai'
depends 'omnibus_updater'
depends 'openssh'
depends 'postfix'
depends 'rackspace_cloudbackup'
depends 'rackspace_iptables'
depends 'rsyslog'
depends 'statsd'
depends 'sudo'
depends 'timezone-ii'
depends 'user'
depends 'yum'
depends 'elkstack'
depends 'elasticsearch'
depends 'java'
