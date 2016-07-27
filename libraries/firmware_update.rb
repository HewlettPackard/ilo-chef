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
  # Class for Ilo Firmware Actions
  class FirmwareUpdate < ChefCompat::Resource
    require_relative 'ilo_helper'
    include IloCookbook::IloHelper

    resource_name :ilo_firmware_update

    property :ilos, Array, required: true
    property :fw_uri, String, required: true
    property :fw_version, Float, required: true

    action_class do
      include IloHelper
    end

    action :upgrade do
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        cur_val = client.get_fw_version.split(' ').first.to_f
        next if cur_val == fw_version
        converge_by "Upgrade ilo #{client.host} firmware to '#{fw_version}'" do
          client.set_fw_upgrade(fw_uri)
        end
      end
    end

  end
end
