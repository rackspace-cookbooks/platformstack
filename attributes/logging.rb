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
