PlatformStack
=============

PlatformStack

You need to at least set `node['newrelic']['license']`, as well as setting these to false if you want to test this cookbook locally:
```
    node['platformstack']['cloud_monitoring']['enabled']
    node['platformstack']['cloud_backup']['enabled']
```

This cookbook is intended to install things that are NOT specific to DevOps support level at Rackspace. Contrast this with (https://github.com/rackops/rackops_rolebook)[rackops_rolebook] cookbook which performs configuration specifically for DevOps customers.

Specifically, this cookbook will, with appropriate flags, install and/or configure:
- Chef client. Note: chef-client will not start automatically, we need to re-run chef-client after first convergance
- Cloud monitoring and Newrelic
- Cloud backup
- Iptables and SSH
- Postfix
- Locale/Timezone
- NTP
- Logstash and rsyslog

