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
  # Class for Secure Boot Actions
  class SecureBoot < BaseResource
    resource_name :ilo_secure_boot

    load_base_properties
    property :enable, [TrueClass, FalseClass], default: false

    # The Unified Extensible Firmware Interface (UEFI) provides a higher level of security by protecting against unauthorized Operating Systems
    # and malware rootkit attacks, validating that only authenticated ROMs, pre-boot applications, and OS boot loaders that have been
    # digitally signed are run.
    action :set do
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        cur_val = client.get_uefi_secure_boot
        next if cur_val == enable
        converge_by "Set ilo #{client.host} secure boot to '#{enable}'" do
          client.set_uefi_secure_boot(enable)
        end
      end
    end

  end
end
