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
  # Class for iLO Date Time Actions
  class DateTime < BaseResource
    resource_name :ilo_date_time

    load_base_properties
    property :time_zone, String
    property :ntp_servers, Array
    property :use_dhcpv4, [TrueClass, FalseClass]

    action :set do
      error_msg = 'Please provide the :time_zone and/or :ntp_servers properties or the :use_dhcpv4 property!'
      raise error_msg unless time_zone || ntp_servers || !use_dhcpv4.nil?
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        unless use_dhcpv4.nil?
          cur_val = client.get_ntp
          unless cur_val == use_dhcpv4
            converge_by "#{use_dhcpv4 ? 'Enable' : 'Disable'} iLO #{client.host} DHCPv4-supplied time settings" do
              client.set_ntp(use_dhcpv4)
            end
          end
        end
        if ntp_servers
          cur_val = client.get_ntp_servers
          unless cur_val == ntp_servers
            converge_by "Set iLO #{client.host} NTP servers from '#{cur_val}' to '#{ntp_servers}'" do
              client.set_ntp_servers(ntp_servers)
            end
          end
        end
        if time_zone
          cur_val = client.get_time_zone
          unless cur_val == time_zone
            converge_by "Set iLO #{client.host} time zone from '#{cur_val}' to '#{time_zone}'" do
              client.set_time_zone(time_zone)
            end
          end
        end
      end
    end

  end
end
