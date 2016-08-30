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
  # Class for Ilo Bios Actions
  class Bios < BaseResource
    require 'resolv'
    resource_name :ilo_bios

    load_base_properties
    property :settings, Hash # See the API docs for what settings are available

    action :set do
      raise 'Please provide a :settings property (Hash)' unless settings
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        begin
          current = client.get_bios_settings
          raise unless current && current.is_a?(Hash)
        rescue StandardError => e
          Chef::Log.error "Failed to get iLO BIOS settings for #{client.host}. Details:"
          Chef::Log.error e.message
          next
        end
        changes = []
        set = JSON.parse(settings.to_json) # Convert to/from JSON to match types from API response
        set.each do |key, val|
          next if val == current[key]
          changes.push(key: key, desired: val, current: current[key])
        end
        if changes.empty?
          Chef::Log.info "BIOS settings for iLO at #{client.host} are similar. No update necessary."
          next
        else
          text = ''
          changes.each { |c| text << "\n    #{c[:key]}: #{c[:current] || 'nil'} -> #{c[:desired] || 'nil'}" }
          converge_by "Set BIOS settings on iLO at #{client.host}#{text}\n" do
            client.set_bios_settings(settings)
          end
        end
      end
    end

    action :revert do
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        cur_val = client.get_bios_baseconfig
        next if cur_val == 'default'
        converge_by "Reverting ilo #{ilo} to default bios base configuration" do
          client.revert_bios
        end
      end
    end

  end
end
