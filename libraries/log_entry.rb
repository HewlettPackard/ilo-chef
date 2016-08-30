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
  # Class for Ilo Log Actions
  class LogEntry < BaseResource
    resource_name :ilo_log_entry

    load_base_properties
    property :log_type, String, required: true, equal_to: ['IEL', 'IML', :IEL, :IML]
    property :severity_level, String, equal_to: ['OK', 'Warning', 'Critical']
    property :dump_file, String
    property :owner, [String, Integer], default: ENV['USER'] || ENV['USERNAME']
    property :group, [String, Integer], default: ENV['USER'] || ENV['USERNAME']
    property :duration, Integer, default: 24

    action :dump do
      raise 'Please set the :dump_file property (String)' unless dump_file
      load_sdk
      dump_content = {}
      ilos.each do |ilo|
        client = build_client(ilo)
        host = ilo[:host] || ilo['host']
        dump_content[host.to_s] = client.get_logs(severity_level, duration, log_type).to_yaml
      end
      file dump_file do
        owner owner
        group group
        content dump_content.to_yaml
      end
    end

    action :clear do
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        next if client.logs_empty?(log_type)
        converge_by "Clear ilo #{client.host} #{log_type} logs" do
          client.clear_logs(log_type)
        end
      end
    end

  end
end
