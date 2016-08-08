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

if defined?(ChefSpec)

  ilo_resources = {
    ilo_account_service:          [:create, :delete, :changePassword],
    ilo_bios:                     [:revert, :set],
    ilo_boot_settings:            [:revert, :set, :dump],
    ilo_chassis:                  [:dump],
    ilo_computer_details:         [:dump],
    ilo_computer_system:          [:set],
    ilo_date_time:                [:set],
    ilo_firmware_update:          [:upgrade],
    ilo_https_cert:               [:import, :generate_csr, :dump_csr],
    ilo_log_entry:                [:clear, :dump],
    ilo_manager_network_protocol: [:set],
    ilo_power:                    [:poweron, :poweroff, :resetsys, :resetilo],
    ilo_secure_boot:              [:set],
    ilo_service_root:             [:dump],
    ilo_snmp_service:             [:configure],
    ilo_user:                     [:create, :delete],
    ilo_virtual_media:            [:insert, :eject]
  }

  ilo_resources.each do |resource_type, actions|
    actions.each do |action|
      method_name = "#{action}_#{resource_type}"
      define_method(method_name) do |resource_name|
        ChefSpec::Matchers::ResourceMatcher.new(resource_type, action, resource_name)
      end
    end
  end
end
