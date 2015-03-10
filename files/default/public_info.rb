# available at https://github.com/rackops/public_info
#
# Copyright:: Copyright (c) 2014 Rackspace, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'json'
require 'net/http'

Ohai.plugin(:Publicinfo) do
  provides 'public_info'

  collect_data(:linux) do
    uri = URI.parse('http://whoami.rackops.org/api')
    # Handle errors and no response for whoami.rackops.org
    begin
      http = Net::HTTP.new(uri.host, uri.port)
      response = http.get(uri.request_uri).body
    rescue
      uri = URI.parse('http://dazzlepod.com/ip/me.json')
      http = Net::HTTP.new(uri.host, uri.port)
      response = http.get(uri.request_uri).body
    end
    results = JSON.parse(response)
    if results.nil?
      Ohai::Log.debug('Failed to return Public_info results')
    else
      public_info Mash.new
      public_info[:remote_ip] = results.key?('remote_ip') ? results['remote_ip'] : results['ip']
      public_info[:X_Forwarded] = results['X_Forwarded']
      public_info[:asn] = results['asn']
      public_info[:city] = results['city']
      public_info[:country] = results['country']
    end
  end
end
