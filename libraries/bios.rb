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
  # Class for Ilo Bios Actions
  class Bios < ChefCompat::Resource
    require 'resolv'
    action_class do
      include IloCookbook::Helper
    end
    resource_name :ilo_bios

    property :ilos, Array, required: true
    property :uefi_shell_startup, String, equal_to: ['Enabled', 'Disabled']
    property :uefi_shell_startup_location, String, equal_to: ['Auto', 'NetworkLocation', 'AttachedMedia']
    property :uefi_shell_startup_url, String, regex: %r{^$|^(ht|f)tp:\/\/[A-Za-z0-9]([.\w]*:?[A-Za-z0-9])([A-Za-z0-9\-\.\?,'\/\\\+&;%\$#~=_]*)?(.nsh)$}
    property :dhcpv4, String, equal_to: ['Enabled', 'Disabled']
    property :ipv4_address, String, regex: Resolv::IPv4::Regex
    property :ipv4_gateway, String, regex: Resolv::IPv4::Regex
    property :ipv4_primary_dns, String, regex: Resolv::IPv4::Regex
    property :ipv4_secondary_dns, String, regex: Resolv::IPv4::Regex
    property :ipv4_subnet_mask, String, regex: Resolv::IPv4::Regex
    property :url_boot_file, String, regex: %r{^$|^(ht|f)tp:\/\/[A-Za-z0-9]([.\w]*:?[A-Za-z0-9])([A-Za-z0-9\-\.\?,'\/\\\+&;%\$#~=_]*)?(.iso|.efi)$}
    property :service_name, String
    property :service_email, String

    action :set do
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        configs = {
          'uefi_shell_startup' => {
            'current' => client.get_uefi_shell_startup,
            'new' => {
              'UefiShellStartup' => uefi_shell_startup,
              'UefiShellStartupLocation' => uefi_shell_startup_location,
              'UefiShellStartupUrl' => uefi_shell_startup_url
            }
          },
          'bios_dhcp' => {
            'current' => client.get_bios_dhcp,
            'new' => {
              'Dhcpv4' => dhcpv4,
              'Ipv4Address' => ipv4_address,
              'Ipv4Gateway' => ipv4_gateway,
              'Ipv4PrimaryDNS' => ipv4_primary_dns,
              'Ipv4SecondaryDNS' => ipv4_secondary_dns,
              'Ipv4SubnetMask' => ipv4_subnet_mask
            }
          },
          'url_boot_file' => {
            'current' => client.get_url_boot_file,
            'new' => url_boot_file
          },
          'bios_service' => {
            'current' => client.get_bios_service,
            'new' => {
              'ServiceName' => service_name,
              'ServiceEmail' => service_email
            }
          }
        }
        configs.each do |key, value|
          next if value['current'] == value['new']
          next if value['new'].nil?
          case key
          when 'uefi_shell_startup'
            converge_by "Set ilo #{client.host} UEFI Shell Startup from '#{value['current']}' to '#{value['new']}'" do
              client.set_uefi_shell_startup(uefi_shell_startup, uefi_shell_startup_location, uefi_shell_startup_url)
            end
          when 'bios_dhcp'
            converge_by "Set ilo #{client.host} Bios DHCP from '#{value['current']}' to '#{value['new']}'" do
              client.set_bios_dhcp(dhcpv4, ipv4_address, ipv4_gateway, ipv4_primary_dns, ipv4_secondary_dns, ipv4_subnet_mask) if dhcpv4 == 'Disabled'
              client.set_bios_dhcp(dhcpv4) if dhcpv4 == 'Enabled'
            end
          when 'url_boot_file'
            converge_by "Set ilo #{client.host} URL Boot File from '#{value['current']}' to '#{value['new']}'" do
              client.set_url_boot_file(url_boot_file)
            end
          when 'bios_service'
            converge_by "Set ilo #{client.host} Bios Service from '#{value['current']}' to '#{value['new']}'" do
              client.set_bios_service(service_name, service_email)
            end
          end
        end
      end
    end

    action :revert do
      load_sdk
      ilos.each do |ilo|
        client = build_client(ilo)
        cur_val = client.get_bios_baseconfig
        next if cur_val == 'default'
        converge_by "Reverting ilo #{ilo} to default bios base configuration" do
          client.revert_bios
        end
      end
    end

  end
end
