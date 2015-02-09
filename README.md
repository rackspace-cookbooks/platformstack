[![Stories in Ready](https://badge.waffle.io/rackspace-cookbooks/platformstack.png?label=ready&title=Ready)](https://waffle.io/rackspace-cookbooks/platformstack)
[![Circle CI](https://circleci.com/gh/rackspace-cookbooks/platformstack/tree/master.svg?style=svg)](https://circleci.com/gh/rackspace-cookbooks/platformstack/tree/master)
# PlatformStack

This cookbook installs and sets up commonly used things that we consider useful or standard (such as setting the timezone to UTC). This cookbook installs things that are and are NOT specific to DevOps support level at Rackspace. Much of the distinction is made in things named 'rackops' (managed) vs. 'platform' (managed and unmanaged). This cookbook was merged with one originally named 'rackops_rolebook' as [part of RFC 006](https://github.com/AutomationSupport/devops-rfc/blob/master/rfc-006-combine_commons.md).

## general notes

Most things can be toggled with an `enabled` attribute and some things are disabled by default.  We lock down openssh pretty hard by default as well.

## rackspace services
If you wish to use rackspace_cloudbackup or cloud monitoring you will need to set the following attributes:

    node['rackspace']['cloud_credentials']['username']
    node['rackspace']['cloud_credentials']['api_key']

## specific notes
#### iptables
- We only start iptables if `node['platformstack']['rackconnect']` is false
- We set up the rackconnect user and enable password auth via openssh if `node['platformstack']['rackconnect']` is true
- We allow ssh from the world by default (controled by the `node['platformstack']['iptables']['allow_ssh_from_world']` attribute

#### locale
Fairly simple and set by the `node['platformstack']['locale']` attribute

#### monitors
Sets up monitoring for the following by default:
- cpu
- disk
- load
- memory
- network
- filesystem
 - for non-memory type filesystems by default
- service
 - only enabled if set up via the `node['platformstack']['cloud_monitoring']['service']['name']` attribute

You can set the period and timeout along with the critical and warning thresholds via attributes, as well as configure custom monitors. Check the cloud_monitoring attributes file for more info.

#### default
Sets the timezone to UTC by default.

We run last in the run list via a notification / ruby_block trick to run last so that we can collect all overrides for node attributes.

This cookbook sets up the following (default disabled will be noted by a '*')
- apt:: default if debian
- locale
- ntp
- timezone
- auto-patching
- chef-client
- postfix
- newrelic (if license exists)
- rackspace_cloudbackup
- *statsd
- *logstash_rsyslog client
- *client-rekey
- omnibus_updater
- monitors
- iptables
- openssh

[1]: https://github.com/rackops/rackops_rolebook
