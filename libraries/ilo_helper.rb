# (c) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

module IloCookbook
  ## Helper module to load the ilo-ruby-sdk gem and build the client object
  module Helper
    # Load (and install if necessary) the ilo-sdk
    def load_sdk
      gem 'ilo-sdk', node['ilo']['ruby_sdk_version']
      require 'ilo-sdk'
      Chef::Log.debug("Found gem ilo-sdk (version #{node['ilo']['ruby_sdk_version']})")
    rescue LoadError
      Chef::Log.info("Did not find gem ilo-sdk (version #{node['ilo']['ruby_sdk_version']}). Installing now")
      chef_gem 'ilo-sdk' do
        version node['ilo']['ruby_sdk_version']
        compile_time true if Chef::Resource::ChefGem.method_defined?(:compile_time)
      end
      require 'ilo-sdk'
    end

    # Makes it easy to build a ILO_SDK::Client object
    # @param [Hash, ILO_SDK::Client] ilo Machine info or client object.
    # @return [ILO_SDK::Client] Client object
    def build_client(ilo)
      case ilo
      when ILO_SDK::Client
        return ilo
      when Hash
        log_level = ilo['log_level'] || ilo[:log_level] || Chef::Log.level
        return ILO_SDK::Client.new(ilo.merge(log_level: log_level))
      else
        raise "Invalid client #{ilo}. Must be a hash or ILO_SDK::Client"
      end
    end
  end
end
