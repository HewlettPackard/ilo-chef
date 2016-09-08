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

require_relative 'base_resource'

module IloCookbook
  # Class for Service Root Actions
  class ServiceRoot < BaseResource
    resource_name :ilo_service_root

    load_base_properties
    property :schema_prefix, String
    property :registry_prefix, String
    property :schema_file, String
    property :registry_file, String
    property :owner, [String, Integer], default: ENV['USER'] || ENV['USERNAME']
    property :group, [String, Integer], default: ENV['USER'] || ENV['USERNAME']

    action :dump do
      raise 'Please provide the :schema_file and/or :registry_file properties!' unless schema_file || registry_file
      raise 'Please provide the :schema_prefix property!' if schema_file && schema_prefix.nil?
      raise 'Please provide the :registry_prefix property!' if registry_file && registry_prefix.nil?
      load_sdk
      schema_content = {}
      registry_content = {}
      ilos.each do |ilo|
        client = build_client(ilo)
        host = ilo[:host] || ilo['host']
        schema_content[host.to_s] = client.get_schema(schema_prefix).to_yaml if schema_file
        registry_content[host.to_s] = client.get_registry(registry_prefix).to_yaml if registry_file
      end
      if schema_file
        file schema_file do
          owner owner
          group group
          content schema_content.to_yaml
        end
      end
      if registry_file
        file registry_file do
          owner owner
          group group
          content registry_content.to_yaml
        end
      end
    end

  end
end
