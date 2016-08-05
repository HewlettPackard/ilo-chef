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
  ## Class for iLO Account Service Actions
  class ManagerAccount < BaseResource
    resource_name :ilo_manager_account

    load_base_properties
    property :username, String, required: true
    property :login_priv, [TrueClass, FalseClass]
    property :remote_console_priv, [TrueClass, FalseClass]
    property :user_config_priv, [TrueClass, FalseClass]
    property :virtual_media_priv, [TrueClass, FalseClass]
    property :virtual_power_and_reset_priv, [TrueClass, FalseClass]
    property :ilo_config_priv, [TrueClass, FalseClass]

    action :set_privileges do
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        cur_privileges = client.get_account_privileges(username)
        privileges = {
          'LoginPriv' => login_priv,
          'RemoteConsolePriv' => remote_console_priv,
          'UserConfigPriv' => user_config_priv,
          'VirtualMediaPriv' => virtual_media_priv,
          'VirtualPowerAndResetPriv' => virtual_power_and_reset_priv,
          'iLOConfigPriv' => ilo_config_priv
        }
        next if cur_privileges == privileges
        converge_by "Change account privileges for #{username} on iLO #{client.host}" do
          client.set_account_privileges(username, login_priv, remote_console_priv, user_config_priv,
                                        virtual_media_priv, virtual_power_and_reset_priv, ilo_config_priv)
        end
      end
    end
  end
end
