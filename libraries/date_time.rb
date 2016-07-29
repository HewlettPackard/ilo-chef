# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
module IloCookbook
  # Class for Ilo Date Time Actions
  class DateTime < ChefCompat::Resource
    action_class do
      include IloCookbook::Helper
    end

    resource_name :ilo_date_time

    property :ilos, Array, required: true
    property :time_zone, String
    property :ntp_servers, Array
    property :use_ntp, [TrueClass, FalseClass]

    action :set do
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        if time_zone
          cur_val = client.get_time_zone
          next if cur_val == time_zone
          converge_by "Set ilo #{client.host} time zone from '#{cur_val}' to '#{time_zone}'" do
            client.set_time_zone(time_zone)
          end
        end
        unless use_ntp.nil?
          cur_val = client.get_ntp
          next if cur_val == use_ntp
          converge_by "Set ilo #{client.host} NTP use from '#{cur_val}' to '#{use_ntp}'" do
            client.set_ntp(use_ntp)
          end
        end
        if ntp_servers
          cur_val = client.get_ntp_servers
          next if cur_val == ntp_servers
          converge_by "Set ilo #{client.host} NTP Servers from '#{cur_val}' to '#{ntp_servers}'" do
            client.set_ntp_servers(ntp_servers)
          end
        end
      end
    end

  end
end
