require 'resolv'

actions :revert, :set, :dump

property :ilos, Array, :required => true
property :uefi_shell_startup, String, :equal_to => ['Enabled', 'Disabled']
property :uefi_shell_startup_location, String, :equal_to => ['Auto', 'NetworkLocation', 'AttachedMedia']
property :uefi_shell_startup_url, String, :regex => /^$|^(ht|f)tp:\/\/[A-Za-z0-9]([-.\w]*[A-Za-z0-9])([A-Za-z0-9\-\.\?,'\/\\\+&;%\$#~=_]*)?(.nsh)$/
property :dhcpv4, String, :equal_to => ['Enabled', 'Disabled']
property :ipv4_address, String, :regex => Resolv::IPv4::Regex
property :ipv4_gateway, String, :regex => Resolv::IPv4::Regex
property :ipv4_primary_dns, String, :regex => Resolv::IPv4::Regex
property :ipv4_secondary_dns, String, :regex => Resolv::IPv4::Regex
property :ipv4_subnet_mask, String, :regex => Resolv::IPv4::Regex
property :url_boot_file, String, :regex => /^$|^(ht|f)tp:\/\/[A-Za-z0-9]([-.\w]*[A-Za-z0-9])([A-Za-z0-9\-\.\?,'\/\\\+&;%\$#~=_]*)?(.iso|.efi)$/
property :service_name, String
property :service_email, String
property :dump_file, String
property :boot_order, Array
property :boot_target, String
property :owner, [String, Integer], default: node['current_user']
property :group, [String, Integer], default: node['current_user']

include IloHelper

action :revert do
  load_sdk(self)
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_val = client.get_bios_baseconfig
    next if cur_val == 'default'
    converge_by "Reverting ilo #{ilo} to default bios base configuration" do
      client.revert_bios
    end
  end
end

action :set do
  load_sdk(self)
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
      },
      'boot_order' => {
        'current' => client.get_boot_order,
        'new' => boot_order
      },
      'temporary_boot_order' => {
        'current' => client.get_temporary_boot_order,
        'new' => boot_target
      }
    }
    configs.each do |key, value|
      next if value['current'] == value['new']
      next if value['new'] == nil
      if key == 'uefi_shell_startup'
        converge_by "" do
          client.set_uefi_shell_startup(uefi_shell_startup, uefi_shell_startup_location, uefi_shell_startup_url)
        end
      end
      if key == 'bios_dhcp'
        converge_by "Set ilo #{client.host} Bios DHCP from '#{value['current']}' to '#{value['new']}'" do
          client.set_bios_dhcp(dhcpv4, ipv4_address, ipv4_gateway, ipv4_primary_dns, ipv4_secondary_dns, ipv4_subnet_mask) if dhcpv4 == "Disabled"
          client.set_bios_dhcp(dhcpv4) if dhcpv4 == 'Enabled'
        end
      end
      if key == 'url_boot_file'
        converge_by "Set ilo #{client.host} URL Boot File from '#{value['current']}' to '#{value['new']}'" do
          client.set_url_boot_file(url_boot_file)
        end
      end
      if key == 'bios_service'
        converge_by "Set ilo #{client.host} Bios Service from '#{value['current']}' to '#{value['new']}'" do
          client.set_bios_service(service_name, service_email)
        end
      end
      if key == 'boot_order'
        converge_by "Set ilo #{client.host} Boot Order from '#{value['current']}' to '#{value['new']}'" do
          client.set_boot_order(boot_order)
        end
      end
      if key == 'temporary_boot_order'
        converge_by "Set ilo #{client.host} Temporary Boot Order from '#{value['current']}' to '#{value['new']}'" do
          client.set_temporary_boot_order(boot_target)
        end
      end
    end
  end
end

action :dump do
  load_sdk(self)
  dumpContent = ""
  ilos.each do |ilo|
    client = build_client(ilo)
    dumpContent = dumpContent + client.get_all_boot_order.to_yaml + "\n"
  end
  file dump_file do
    owner owner
    group group
    content dumpContent
  end
end
