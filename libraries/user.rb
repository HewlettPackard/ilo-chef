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
  ## Class for iLO  User Actions
  class User < BaseResource
    resource_name :ilo_user

    load_base_properties
    property :username, String, required: true, name_property: true
    property :password, String
    property :login_priv, [TrueClass, FalseClass], default: false
    property :remote_console_priv, [TrueClass, FalseClass], default: false
    property :user_config_priv, [TrueClass, FalseClass], default: false
    property :virtual_media_priv, [TrueClass, FalseClass], default: false
    property :virtual_power_and_reset_priv, [TrueClass, FalseClass], default: false
    property :ilo_config_priv, [TrueClass, FalseClass], default: false

    action :create do
      load_sdk
      privileges = {
        'LoginPriv' => login_priv,
        'RemoteConsolePriv' => remote_console_priv,
        'UserConfigPriv' => user_config_priv,
        'VirtualMediaPriv' => virtual_media_priv,
        'VirtualPowerAndResetPriv' => virtual_power_and_reset_priv,
        'iLOConfigPriv' => ilo_config_priv
      }
      ilos.each do |ilo|
        client = build_client(ilo)
        cur_users = client.get_users
        if cur_users.include? username # User exists
          cur_privileges = client.get_account_privileges(username)
          if cur_privileges != privileges
            converge_by "Update account privileges for user #{username} on iLO #{client.host}" do
              client.set_account_privileges(username, privileges)
            end
          end
          next unless password
          converge_by "Update password for user #{username} on iLO #{client.host}" do
            client.change_password(username, password)
          end
        else # Create the user
          raise "Cannot create user #{username}: No password set!" unless password
          converge_by "Create user #{username} on iLO #{client.host}" do
            client.create_user(username, password)
            client.set_account_privileges(username, privileges)
          end
        end
      end
    end

    action :delete do
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        cur_users = client.get_users
        next unless cur_users.include? username
        converge_by "Delete user #{username} on iLO #{client.host}'" do
          client.delete_user(username)
        end
      end
    end
  end
end
