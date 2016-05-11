ilo =
{
    host: '16.85.179.65',
    user: 'Admin',
    password: 'admin123',
    ssl_enabled: false
}

iLO_bios 'set the uefi' do
  ilos [ilo]
  uefi_shell_startup 'Disabled'
  uefi_shell_startup_url ''
  uefi_shell_startup_location 'Auto'
  action :set
end

iLO_bios 'set the bios and boot order' do
  ilos [ilo]
  dhcpv4 'Enabled'
  ipv4_address '0.0.0.0'
  ipv4_gateway '0.0.0.0'
  ipv4_primary_dns '0.0.0.0'
  ipv4_secondary_dns '0.0.0.0'
  ipv4_subnet_mask '0.0.0.0'
  url_boot_file ''
  service_name 'JERRY'
  service_email ''
  boot_order [
    "Generic.USB.1.1",
    "HD.Emb.1.1",
    "HD.Emb.1.2",
    "NIC.LOM.1.1.IPv4",
    "NIC.LOM.1.1.IPv6",
    "FD.Virtual.1.1"
  ]
  boot_target 'None'
  action :set
end

iLO_bios 'set the uefi different' do
  ilos [ilo]
  uefi_shell_startup 'Enabled'
  uefi_shell_startup_url 'http://wwww.test.nsh'
  uefi_shell_startup_location 'NetworkLocation'
  action :set
end

iLO_bios 'set the bios and boot order different' do
  ilos [ilo]
  dhcpv4 'Enabled'
  ipv4_address '111.111.111.111'
  ipv4_gateway '111.111.111.111'
  ipv4_primary_dns '111.111.111.111'
  ipv4_secondary_dns '111.111.111.111'
  ipv4_subnet_mask '111.111.111.111'
  url_boot_file 'http://wwww.urlbootfiletest.iso'
  service_name 'bik'
  service_email 'bik.bajwa@hpe.com'
  boot_order [
    "FD.Virtual.1.1",
    "Generic.USB.1.1",
    "HD.Emb.1.1",
    "HD.Emb.1.2",
    "NIC.LOM.1.1.IPv4",
    "NIC.LOM.1.1.IPv6"
  ]
  boot_target 'None'
  action :set
end

iLO_bios 'set the uefi back' do
  ilos [ilo]
  uefi_shell_startup 'Disabled'
  uefi_shell_startup_url ''
  uefi_shell_startup_location 'Auto'
  action :set
end

iLO_bios 'set the bios and boot order back' do
  ilos [ilo]
  dhcpv4 'Enabled'
  ipv4_address '0.0.0.0'
  ipv4_gateway '0.0.0.0'
  ipv4_primary_dns '0.0.0.0'
  ipv4_secondary_dns '0.0.0.0'
  ipv4_subnet_mask '0.0.0.0'
  url_boot_file ''
  service_name 'JERRY'
  service_email ''
  boot_order [
    "Generic.USB.1.1",
    "HD.Emb.1.1",
    "HD.Emb.1.2",
    "NIC.LOM.1.1.IPv4",
    "NIC.LOM.1.1.IPv6",
    "FD.Virtual.1.1"
  ]
  boot_target 'None'
  action :set
end

iLO_bios 'revert the bios' do
  ilos [ilo]
  action :revert
end

iLO_bios 'dump bios and boot info' do
  ilos [ilo]
  dump_file "#{Chef::Config[:file_cache_path]}/bios_boot_dump.txt"
  action :dump
end
