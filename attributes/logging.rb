#
# Cookbook Name:: platformstack
#
# Copyright 2014. Rackspace, US Inc.
#

# turn it on, turn it off.
default['platformstack']['elkstack_logging']['enabled'] = true

# Override this with a different search query if you'd like chef nodes to find
# ELK nodes another way. This query ***MUST NOT*** get search results for
# non-ELKstack cluster nodes, or logs will be lost, and the cluster itself may
# suffer the ability to find other nodes or may fail to achieve quorum.
#
# default['elasticsearch']['discovery']['search_query'] = "tags:elkstack_cluster"

# arbitrary data structure for any arbitrary logstash config
default['platformstack']['elkstack']['custom_logstash']['name'] = []
# Currently for arbitrary logstash configs, the recipe that sets up the logstash file should add:
# node.default['platformstack']['elkstack']['custom_logstash']['name'].push('<service_name>')
# and then populate node['elkstack']['custom_logstash'][service_name][setting] with your values
# default['platformstack']['elkstack']['custom_logstash'][<name>]['name'] = 'my_logstashconfig'
# default['platformstack']['elkstack']['custom_logstash'][<name>]['source'] = 'my_logstashconfig.conf.erb'
# default['platformstack']['elkstack']['custom_logstash'][<name>]['cookbook'] = 'your_cookbook'
# default['platformstack']['elkstack']['custom_logstash'][<name>]['variables'] = { :warning => 'foo' }
