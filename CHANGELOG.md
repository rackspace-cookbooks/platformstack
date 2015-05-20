# 3.1.5

- Run rackspace_cloudbackup normally (not in a ruby block at the end of the run)

# 3.1.4

- Only install tmux on Ubuntu (#205).

# 3.1.3

- Remove .blank? in favor of .empty?

# 3.1.2

- Unpin git cookbook (#200)
- Add additional packages (#201)
- Do not pass false for NR license (#202)

# 3.1.1

- Pin back git cookbook to avoid bug described in https://github.com/rackspace-cookbooks/platformstack/issues/198.

# 3.1.0

- node['openssh']['server']['subsystem'] supports more platforms
- removed rest-client (removed in chef12 as well) in favor of net/http

# 3.0.4
- Rewrite many chef actions into symbols from strings, per https://github.com/rackspace-cookbooks/platformstack/pull/188.

# 3.0.3
- Make sure nothing is done about cloud-monitoring if the the is set to false

# 3.0.2
- Added enable/disable flag for slack_handler recipe.
- Added a toggle for iptables, to enable/disable based on feature flag attribute

# 3.0.1
- Added enable/disable flag for iptables recipe.

# 3.0.0

- Due to the various problems it presents (circular dependencies, kibana Berksfile entries on every cookbook in a 3 mile radius, etc), we are no longer going to activate elkstack by default in platformstack. In order to include elkstack now, simply `include_recipe 'elkstack::agent'` on your node or add it to the runlist directly.

# 2.0.0

- Merge with rackops_rolebook, keeping this cookbook as the result. See RFC 006 and the resulting PR for more information.

# 1.5.3

- Disable force upgrade of omnibus

# 1.5.0

- Setup remote-http monitors from attribute hash.

# 1.4.4

- Remove now-unused logstash_commons references

# 1.4.3

- Add missing dependency (wasn't an error since elkstack depends on it, but still)
- Add a hash to use to configure custom logstash

# 1.4.2

- Guard more of elkstack execution to be sure we don't do anything too early, undoes part of 1.4.2

# 1.4.2

- Remove logic that is already in elkstack::agent

# 1.4.0

- Bump to re-release due to Supermarket upload concerns

# 1.3.0

- Allow wrappers to supply additional custom monitors (always intended, but wasn't implemented)
