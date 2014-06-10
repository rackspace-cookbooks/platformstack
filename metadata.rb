name 'platformstack'
maintainer 'Rackspace US, Inc.'
maintainer_email 'rackspace-cookbooks@rackspace.com'
license 'Apache 2.0'
description 'Provides a full Tomcat stack'

version '0.1.0'

depends 'chef-sugar', '>= 1.3.0'
depends 'newrelic', '>= 1.0.5'
depends 'ntp', '>= 1.6.3'
depends 'openssh', '>= 1.3.0'
depends 'rackspace_iptables', '>= 1.3.1'
depends 'timezone-ii', '>= 0.2.0'
depends 'user', '>= 0.3.0'
depends 'logstash_stack', '>=1.1.0'
