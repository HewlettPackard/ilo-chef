require 'resolv'

actions :revert, :uefi_shell_startup, :set_dhcp, :set_url_boot_file

property :ilos, Array, :required => true
property :value, String, :equal_to => ['Enabled', 'Disabled']
property :location, String, :equal_to => ['Auto', 'NetworkLocation', 'AttachedMedia']
property :url, String, :regex => /^$|^(ht|f)tp:\/\/[A-Za-z0-9]([-.\w]*[A-Za-z0-9])([A-Za-z0-9\-\.\?,'\/\\\+&;%\$#~=_]*)?(.nsh)$/
property :ipv4_address, String, :regex => Resolv::IPv4::Regex
property :ipv4_gateway, String, :regex => Resolv::IPv4::Regex
property :ipv4_primary_dns, String, :regex => Resolv::IPv4::Regex
property :ipv4_secondary_dns, String, :regex => Resolv::IPv4::Regex
property :ipv4_subnet_mask, String, :regex => Resolv::IPv4::Regex
property :url_boot_file, String, :regex => /^$|^(ht|f)tp:\/\/[A-Za-z0-9]([-.\w]*[A-Za-z0-9])([A-Za-z0-9\-\.\?,'\/\\\+&;%\$#~=_]*)?(.iso|.efi)$/
property :service_name, String
property :service_email, String

include ClientHelper

action :revert do
  ilos.each do |ilo|
    client = build_client(ilo)
    converge_by "Revert ilo #{client.host} bios and reset server" do
      client.revert_bios
      client.set_power_state("ForceRestart")
    end
  end
end

action :uefi_shell_startup do
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_val = client.get_uefi_shell_startup
    next if cur_val == {
      'UefiShellStartup' => value,
      'UefiShellStartupLocation' => location,
      'UefiShellStartupUrl' => url
    }
    converge_by "Set ilo #{client.host} UEFI start up to '#{value}'" do
      client.set_uefi_shell_startup(value, location, url)
      client.set_power_state("ForceRestart")
    end
  end
end

action :set_dhcp do
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_val = client.get_bios_dhcp
    next if cur_val == {
      'Dhcpv4' => value,
      'Ipv4Address' => ipv4_address,
      'Ipv4Gateway' => ipv4_gateway,
      'Ipv4PrimaryDNS' => ipv4_primary_dns,
      'Ipv4SecondaryDNS' => ipv4_secondary_dns,
      'Ipv4SubnetMask' => ipv4_subnet_mask
    }
    converge_by "Set ilo #{client.host} DHCP start up to '#{value}'" do
      client.set_bios_dhcp(value, ipv4_address, ipv4_gateway, ipv4_primary_dns, ipv4_secondary_dns, ipv4_subnet_mask) if value == "Disabled"
      client.set_bios_dhcp(value) if value == 'Enabled'
    end
  end
end

action :set_url_boot_file do
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_val = client.get_url_boot_file
    next if cur_val == url_boot_file
    converge_by "Set ilo #{client.host} URL boot file to '#{url_boot_file}'" do
      client.set_url_boot_file(url_boot_file)
      client.set_power_state("ForceRestart")
    end
  end
end

action :set_bios_service do
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_val = client.get_bios_service
    next if cur_val == {
      'ServiceName' => service_name,
      'ServiceEmail' => service_email
    }
    converge_by "Set ilo #{client.host} BIOS service to Name: '#{service_name}' and Email: '#{service_email}'" do
      client.set_bios_service(service_name, service_email)
      client.set_power_state("ForceRestart")
    end
  end
end
