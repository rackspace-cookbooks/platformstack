case node['platform']
when 'debian', 'ubuntu'
  execute 'fix_locale' do
#    environment LC_ALL: 'en_US.UTF-8', LANG: 'en_US.UTF-8', LANGUAGE: 'en_US.UTF-8'
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
