ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_bios 'set bios' do
  ilos [ilo]
  uefi_shell_startup 'Enabled'
  uefi_shell_startup_url 'http://www.test.nsh'
  uefi_shell_startup_location 'NetworkLocation'
  dhcpv4 'Enabled'
  ipv4_address '111.111.111.111'
  ipv4_gateway '111.111.111.111'
  ipv4_primary_dns '111.111.111.111'
  ipv4_secondary_dns '111.111.111.111'
  ipv4_subnet_mask '111.111.111.111'
  url_boot_file 'http://www.urlbootfiletest.iso'
  service_name 'bik'
  service_email 'bik.bajwa@hpe.com'
  action :set
end
