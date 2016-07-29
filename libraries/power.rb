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
  # Class for Ilo Power Actions
  class Power < BaseResource
    resource_name :ilo_power

    load_base_properties

    action :poweron do
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        cur_val = client.get_power_state
        next if cur_val == 'On'
        converge_by "Set ilo #{client.host} power ON" do
          client.set_power_state('On')
        end
      end
    end

    action :poweroff do
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        cur_val = client.get_power_state
        next if cur_val == 'Off'
        converge_by "Set ilo #{client.host} power ForceOff" do
          client.set_power_state('ForceOff')
        end
      end
    end


    action :resetsys do
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        converge_by "Set ilo #{client.host} power ForceRestart" do
          client.set_power_state('ForceRestart')
        end
      end
    end

    action :resetilo do
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        converge_by "Set ilo #{client.host} power Reset" do
          client.reset_ilo
        end
      end
    end

  end
end
