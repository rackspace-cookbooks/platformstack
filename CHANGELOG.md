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
