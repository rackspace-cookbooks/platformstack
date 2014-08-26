name 'platformstack'
maintainer 'Rackspace US, Inc.'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license 'Apache 2.0'
description 'Provides a full Tomcat stack'

version '1.0.3'

%w(ubuntu debian redhat centos).each do |os|
  supports os
end

depends 'apt'
depends 'auto-patch'
depends 'chef-client'
depends 'chef-sugar'
depends 'client-rekey'
depends 'logstash_stack'
depends 'newrelic'
depends 'motd-tail'
depends 'ntp'
depends 'ohai'
depends 'omnibus_updater'
depends 'openssh'
depends 'postfix'
depends 'rackspace_cloudbackup'
depends 'rackspace_iptables'
depends 'statsd'
depends 'sudo'
depends 'timezone-ii'
depends 'user'
depends 'yum'
