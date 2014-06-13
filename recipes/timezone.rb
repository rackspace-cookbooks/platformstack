if platform_family?('debian')
  node.default['tz'] = 'Etc/UTC'
end

include_recipe 'timezone-ii::default'
