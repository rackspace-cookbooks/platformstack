case node['platform']
when 'debian', 'ubuntu'
  execute 'fix_locale' do
    command '/usr/sbin/update-locale LANG=en_US.UTF-8'
    user 'root'
    action 'run'
  end
when 'redhat', 'centos'
  template '/etc/sysconfig/i18n' do
    source 'centos-locale.erb'
    owner 'root'
    group 'root'
    mode '00644'
  end
end
