require 'resolv'

actions :revert, :uefi_shell_startup, :set_dhcp, :set_url_boot_file

property :ilos, Array, :required => true
property :value, String, :equal_to => ['Enabled', 'Disabled']
property :location, String, :equal_to => ['Auto', 'NetworkLocation', 'AttachedMedia']
property :url, String, :regex => /^(ht|f)tp:\/\/[A-Za-z0-9]([-.\w]*[A-Za-z0-9])([A-Za-z0-9\-\.\?,'\/\\\+&;%\$#~=_]*)?(.nsh)$/
property :ipv4_address, String, :regex => Resolv::IPv4::Regex
property :ipv4_gateway, String, :regex => Resolv::IPv4::Regex
property :ipv4_primary_dns, String, :regex => Resolv::IPv4::Regex
property :ipv4_secondary_dns, String, :regex => Resolv::IPv4::Regex
property :ipv4_subnet_mask, String, :regex => Resolv::IPv4::Regex
property :url_boot_file, String, :regex => /^(ht|f)tp:\/\/[A-Za-z0-9]([-.\w]*[A-Za-z0-9])([A-Za-z0-9\-\.\?,'\/\\\+&;%\$#~=_]*)?(.iso|.efi)$/
property :service_name, String
property :service_email, String

include ClientHelper

action :revert do
  ilo_names.each do |ilo|
    machine  = ilono.select{|k,v| k == ilo}[ilo]
    revert_bios(machine)
    reset_server(machine)
  end
end

action :uefi_shell_startup do
  ilo_names.each do |ilo|
    machine  = ilono.select{|k,v| k == ilo}[ilo]
    set_uefi_shell_startup(machine, value, location, url)
    reset_server(machine)
  end
end

action :set_dhcp do
  ilo_names.each do |ilo|
    machine  = ilono.select{|k,v| k == ilo}[ilo]
    set_bios_dhcp(machine, value, ipv4_address, ipv4_primary_dns, ipv4_secondary_dns, ipv4_gateway, ipv4_subnet_mask) if value == "Disabled"
    set_bios_dhcp(machine, value) if value == 'Enabled'
  end
end

action :set_url_boot_file do
  ilo_names.each do |ilo|
    machine  = ilono.select{|k,v| k == ilo}[ilo]
    set_url_boot_file(machine, url_boot_file)
    reset_server(machine)
  end
end

action :set_bios_service do
  ilo_names.each do |ilo|
    machine  = ilono.select{|k,v| k == ilo}[ilo]
    set_bios_service(machine, service_name, service_email)
    reset_server(machine)
  end
end
