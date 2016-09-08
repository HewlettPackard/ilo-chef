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
  # Class for iLO SNMP Service Actions
  class SnmpService < BaseResource
    resource_name :ilo_snmp_service

    load_base_properties
    property :snmp_mode, String, default: 'Agentless', equal_to: ['Agentless', 'Passthru']
    property :snmp_alerts, [TrueClass, FalseClass], default: false

    action :configure do
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        cur_val_mode = client.get_snmp_mode
        cur_val_alerts = client.get_snmp_alerts_enabled
        next if cur_val_mode == snmp_mode && cur_val_alerts == snmp_alerts
        msg = "Set ilo #{client.host} snmp mode from '#{cur_val_mode}' to '#{snmp_mode}'"
        msg << " and alerts enabled from '#{cur_val_alerts}' to '#{snmp_alerts}'"
        converge_by msg do
          client.set_snmp(snmp_mode, snmp_alerts)
        end
      end
    end

  end
end
