# Encoding: utf-8

def git_sync(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:git, :sync, resource_name)
end
