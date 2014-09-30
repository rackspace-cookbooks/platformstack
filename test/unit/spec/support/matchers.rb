# Matchers for chefspec 3
# from opscode-cookbooks/yum/master/libraries/matchers.rb

if defined?(ChefSpec)
  def create_yum_repository(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:yum_repository, :create, resource_name)
  end

  def add_yum_repository(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:yum_repository, :add, resource_name)
  end

  def delete_yum_repository(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:yum_repository, :delete, resource_name)
  end

  def remove_yum_repository(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:yum_repository, :remove, resource_name)
  end

  def create_yum_globalconfig(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:yum_globalconfig, :create, resource_name)
  end

  def delete_yum_globalconfig(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:yum_globalconfig, :delete, resource_name)
  end
end

# from opscode-cookbooks/apt/master/libraries/matchers.rb
if defined?(ChefSpec)
  def add_apt_preference(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:apt_preference, :add, resource_name)
  end

  def remove_apt_preference(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:apt_preference, :remove, resource_name)
  end

  def add_apt_repository(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:apt_repository, :add, resource_name)
  end

  def remove_apt_repository(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:apt_repository, :remove, resource_name)
  end
end

if defined?(ChefSpec)
  # These should live in the sudo cookbook: https://github.com/opscode-cookbooks/sudo/pull/44
  def install_sudo(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sudo, :install, resource_name)
  end

  def remove_sudo(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sudo, :remove, resource_name)
  end
end
