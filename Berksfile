source "https://api.berkshelf.com"

metadata

cookbook 'rackspace_cloudbackup', git: 'git@github.com:rackspace-cookbooks/rackspace_cloudbackup.git'
cookbook 'cron', git: 'git@github.com:rackspace-cookbooks/cron.git'

cookbook 'kibana', '~> 1.3', git: 'git@github.com:lusis/chef-kibana.git'

# until https://github.com/elasticsearch/cookbook-elasticsearch/pull/230
cookbook 'elasticsearch', '~> 0.3', git: 'git@github.com:racker/cookbook-elasticsearch.git'

# until https://github.com/lusis/chef-logstash/pull/336
cookbook 'logstash', '~> 0.9', git: 'git@github.com:racker/chef-logstash.git'

# since we use it so much, don't go to supermarket
cookbook 'elkstack', git: 'git@github.com:rackspace-cookbooks/elkstack.git'
