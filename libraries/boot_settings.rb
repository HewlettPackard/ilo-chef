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
  # Class for Ilo BootSettings actions
  class BiosSettings < BaseResource
    resource_name :ilo_boot_settings

    load_base_properties
    property :dump_file, String
    property :boot_order, Array
    property :boot_target, String
    property :owner, [String, Integer], default: ENV['USER'] || ENV['USERNAME']
    property :group, [String, Integer], default: ENV['USER'] || ENV['USERNAME']

    action :set do
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        configs = {
          'boot_order' => {
            'current' => client.get_boot_order,
            'new' => boot_order
          },
          'temporary_boot_order' => {
            'current' => client.get_temporary_boot_order,
            'new' => boot_target
          }
        }
        configs.each do |key, value|
          next if value['current'] == value['new']
          next if value['new'].nil?
          case key
          when 'boot_order'
            converge_by "Set ilo #{client.host} Boot Order from '#{value['current']}' to '#{value['new']}'" do
              client.set_boot_order(boot_order)
            end
          when 'temporary_boot_order'
            converge_by "Set ilo #{client.host} Temporary Boot Order from '#{value['current']}' to '#{value['new']}'" do
              client.set_temporary_boot_order(boot_target)
            end
          end
        end
      end
    end

    action :revert do
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        cur_val = client.get_boot_baseconfig
        next if cur_val == 'default'
        converge_by "Reverting ilo #{ilo} to default boot base configuration" do
          client.revert_boot
        end
      end
    end

    action :dump do
      raise 'Please provide a :dump_file property (String)' unless dump_file
      load_sdk
      dump_content = ''
      ilos.each do |ilo|
        client = build_client(ilo)
        boot_order = { client.host => client.get_boot_order }
        dump_content = dump_content + boot_order.to_yaml + "\n"
      end
      file dump_file do
        owner owner
        group group
        content dump_content
      end
    end

  end
end
