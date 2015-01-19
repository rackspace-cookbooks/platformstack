# Sets editor for profile.d

case node['platform_family']
when 'debian'
  default['platformstack']['rackops']['editor']['default'] = '/usr/bin/vim.basic'
when 'rhel'
  default['platformstack']['rackops']['editor']['default'] = '/bin/vi'
end
# set the template locations
default['platformstack']['rackops']['templates']['editor-env-var'] = 'platformstack'

# location of ohai_plugins
default['platformstack']['rackops']['ohai_plugins']['repo'] = 'https://github.com/rackerlabs/ohai-plugins.git'
default['platformstack']['rackops']['ohai_plugins']['ref'] = 'master'
