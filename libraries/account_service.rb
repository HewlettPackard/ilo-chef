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
  ## Class for iLO  Account Service Actions
  class AccountService < BaseResource
    resource_name :ilo_account_service

    load_base_properties
    property :username, String, name_property: true
    property :password, String

    action :create do
      warn '[Deprecated] `ilo_account_service` is deprecated. Please use `ilo_user` instead.'
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        cur_users = client.get_users
        next if cur_users.include? username
        converge_by "Create user #{username} on ilo #{client.host}" do
          client.create_user(username, password)
        end
      end
    end

    action :delete do
      warn '[Deprecated] `ilo_account_service` is deprecated. Please use `ilo_user` instead.'
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        cur_users = client.get_users
        next unless cur_users.include? username
        converge_by "Delete user #{username} on ilo #{client.host}'" do
          client.delete_user(username)
        end
      end
    end

    action :changePassword do
      warn '[Deprecated] `ilo_account_service` is deprecated. Please use `ilo_user` instead.'
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        cur_users = client.get_users
        next unless cur_users.include? username
        converge_by "Change password for user #{username} on ilo #{client.host}" do
          client.change_password(username, password)
        end
      end
    end
  end
end
