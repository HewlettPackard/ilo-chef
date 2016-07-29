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
  ## Class for Ilo Account Service Actions
  class AccountService < ChefCompat::Resource
    resource_name :ilo_account_service

    property :ilos, Array, required: true
    property :username, String
    property :password, String

    action_class do
      include IloCookbook::Helper
    end

    action :create do
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
