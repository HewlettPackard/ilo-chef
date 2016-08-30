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
  # Class for Ilo Computer System Actions
  class ComputerSystem < BaseResource
    resource_name :ilo_computer_system

    load_base_properties
    property :asset_tag, String
    property :led_state, [String, Symbol], equal_to: ['Lit', 'Off', :Lit, :Off]
    # TODO: Support more properties

    action :set do
      raise 'Please provide an asset_tag and/or led_state!' unless asset_tag || led_state
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        cur_val_asset_tag = client.get_asset_tag
        cur_val_indicator_led = client.get_indicator_led
        unless cur_val_asset_tag == asset_tag || asset_tag.nil?
          converge_by "Set ilo #{client.host} asset tag from '#{cur_val_asset_tag}' to '#{asset_tag}'" do
            client.set_asset_tag(asset_tag)
          end
        end
        unless cur_val_indicator_led == led_state || led_state.nil?
          converge_by "Set ilo #{client.host} indicator led from '#{cur_val_indicator_led}' to '#{led_state}'" do
            client.set_indicator_led(led_state)
          end
        end
      end
    end

  end
end
