# Module for reusable code for platformstack
module Platformstack
  def self.get_rackops_platformstack(current_node, *keys)
    require 'chef/sugar'

    deprecated_key = ['rackops_rolebook', keys].flatten
    deprecated_value = current_node.deep_fetch(*deprecated_key)

    current_key = ['platformstack', 'rackops', keys].flatten
    current_value = current_node.deep_fetch(*current_key)

    if deprecated_value && !current_value
      Chef::Log.warn("You are using deprecated attribute keys under node['rackops_rolebook']: #{keys.join(',')}")
    elsif deprecated_value && current_value
      Chef::Log.warn("You are using deprecated attribute keys and have non-deprecated keys set at the same time (will use non-deprecated keys first): #{keys.join(',')}")
    end

    # return the preferred value first, followed by the deprecated one
    current_value || deprecated_value
  end
end
