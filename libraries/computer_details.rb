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
  # Class for Ilo Computer Details Actions
  class ComputerDetails < BaseResource
    resource_name :ilo_computer_details

    load_base_properties
    property :dump_file, String
    property :data_bag, String
    property :owner, [String, Integer], default: ENV['USER'] || ENV['USERNAME']
    property :group, [String, Integer], default: ENV['USER'] || ENV['USERNAME']

    action :dump do
      load_sdk
      raise 'Please specify dump_file or data_bag!' unless dump_file || data_bag
      dump_content = {}
      ilos.each do |ilo|
        client = build_client(ilo)
        host = ilo[:host] || ilo['host']
        dump_content[host.to_s] = client.get_computer_details
      end
      if dump_file
        file dump_file do
          owner owner
          group group
          content dump_content.to_yaml
        end
      end
      if data_bag
        unless Chef::DataBag.list.key?(data_bag)
          new_data_bag = Chef::DataBag.new
          new_data_bag.name(data_bag)
          new_data_bag.save
        end
        dump_content.each do |host, data|
          new_data = { 'id' => host }.merge(data)
          begin
            item = data_bag_item(data_bag, host)
          rescue
            item = Chef::DataBagItem.new
            item.data_bag(data_bag)
          end
          item.raw_data = new_data
          item.save
        end
      end
    end

  end
end
