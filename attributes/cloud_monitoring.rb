default['platformstack']['cloud_monitoring']['cpu']['disabled'] = false
default['platformstack']['cloud_monitoring']['cpu']['alarm'] = false
default['platformstack']['cloud_monitoring']['cpu']['period'] = 90
default['platformstack']['cloud_monitoring']['cpu']['timeout'] = 30
default['platformstack']['cloud_monitoring']['cpu']['crit'] = 95
default['platformstack']['cloud_monitoring']['cpu']['warn'] = 90

default['platformstack']['cloud_monitoring']['disk']['disabled'] = false
default['platformstack']['cloud_monitoring']['disk']['alarm'] = false
default['platformstack']['cloud_monitoring']['disk']['target'] = '/dev/xvda1'
default['platformstack']['cloud_monitoring']['disk']['target_mountpoint'] = '/'
default['platformstack']['cloud_monitoring']['disk']['period'] = 60
default['platformstack']['cloud_monitoring']['disk']['timeout'] = 30
default['platformstack']['cloud_monitoring']['disk']['alarm_criteria'] = ''

default['platformstack']['cloud_monitoring']['filesystem']['disabled'] = false
default['platformstack']['cloud_monitoring']['filesystem']['alarm'] = false
default['platformstack']['cloud_monitoring']['filesystem']['period'] = 60
default['platformstack']['cloud_monitoring']['filesystem']['timeout'] = 30
default['platformstack']['cloud_monitoring']['filesystem']['target'] = '/'
default['platformstack']['cloud_monitoring']['filesystem']['crit'] = 90
default['platformstack']['cloud_monitoring']['filesystem']['warn'] = 80

default['platformstack']['cloud_monitoring']['load']['disabled'] = false
default['platformstack']['cloud_monitoring']['load']['alarm'] = false
default['platformstack']['cloud_monitoring']['load']['period'] = 60
default['platformstack']['cloud_monitoring']['load']['timeout'] = 30
default['platformstack']['cloud_monitoring']['load']['crit'] = 3
default['platformstack']['cloud_monitoring']['load']['warn'] = 2

default['platformstack']['cloud_monitoring']['memory']['disabled'] = false
default['platformstack']['cloud_monitoring']['memory']['alarm'] = false
default['platformstack']['cloud_monitoring']['memory']['period'] = 60
default['platformstack']['cloud_monitoring']['memory']['timeout'] = 30
default['platformstack']['cloud_monitoring']['memory']['crit'] = 95
default['platformstack']['cloud_monitoring']['memory']['warn'] = 90

default['platformstack']['cloud_monitoring']['network']['disabled'] = false
default['platformstack']['cloud_monitoring']['network']['alarm'] = false
default['platformstack']['cloud_monitoring']['network']['target'] = 'eth0'
default['platformstack']['cloud_monitoring']['network']['period'] = 60
default['platformstack']['cloud_monitoring']['network']['timeout'] = 30
default['platformstack']['cloud_monitoring']['network']['recv']['crit'] = '76000'
default['platformstack']['cloud_monitoring']['network']['recv']['warn'] = '56000'
default['platformstack']['cloud_monitoring']['network']['send']['crit'] = '76000'
default['platformstack']['cloud_monitoring']['network']['send']['warn'] = '56000'

default['platformstack']['cloud_monitoring']['enabled'] = true
