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
  # Class for Ilo Chassis Actions
  class Chassis < BaseResource
    resource_name :ilo_chassis

    load_base_properties
    property :power_metrics_file, String
    property :thermal_metrics_file, String
    property :owner, [String, Integer], default: ENV['USER'] || ENV['USERNAME']
    property :group, [String, Integer], default: ENV['USER'] || ENV['USERNAME']

    action :dump do
      raise 'Please provide a power_metrics_file and/or thermal_metrics_file!' unless power_metrics_file || thermal_metrics_file
      load_sdk
      power_metrics = ''
      thermal_metrics = ''
      ilos.each do |ilo|
        client = build_client(ilo)
        power_metrics = power_metrics + client.get_power_metrics.to_yaml + "\n" if power_metrics_file
        thermal_metrics = thermal_metrics + client.get_thermal_metrics.to_yaml + "\n" if thermal_metrics_file
      end
      if power_metrics_file
        file power_metrics_file do
          owner owner
          group group
          content power_metrics
        end
      end
      if thermal_metrics_file
        file thermal_metrics_file do
          owner owner
          group group
          content thermal_metrics
        end
      end
    end

  end
end
