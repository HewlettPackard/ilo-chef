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
  # Class for Ilo Virtual Media Actions
  class VirtualMedia < BaseResource
    resource_name :ilo_virtual_media

    load_base_properties
    property :iso_uri, String, required: true, regex: %r{^$|^(ht|f)tp:\/\/[A-Za-z0-9]([.\w:]*:?[A-Za-z0-9])([A-Za-z0-9\-\.\?,'\/\\\+&;%\$#~=_]*)?(.iso)$}

    action :insert do
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        cur_val = client.get_virtual_media
        cur_val.each do |key, hash|
          if hash['MediaTypes'].include?('CD') || hash['MediaTypes'].include?('DVD')
            next if client.virtual_media_inserted?(key)
            converge_by "Insert ilo #{client.host} Virtual Media Image from '#{iso_uri}'" do
              client.insert_virtual_media(key, iso_uri)
            end
          end
        end
      end
    end

    action :eject do
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        cur_val = client.get_virtual_media
        cur_val.each do |key, hash|
          if hash['MediaTypes'].include?('CD') || hash['MediaTypes'].include?('DVD')
            next unless client.virtual_media_inserted?(key)
            converge_by "Eject ilo #{client.host} Virtual Media" do
              client.eject_virtual_media(key)
            end
          end
        end
      end
    end

  end
end
