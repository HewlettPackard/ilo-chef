ilo = {
  host: 'ilo.example.com',
  user: 'Admin',
  password: 'secret123'
}

ilo_bios 'set bios' do
  ilos [ilo]
  settings(
    UefiShellStartup: 'Enabled',
    UefiShellStartupLocation: 'Auto',
    UefiShellStartupUrl: 'http://www.uefi.nsh',
    Dhcpv4: 'Enabled',
    Ipv4Address: '10.1.1.0',
    Ipv4Gateway: '10.1.1.11',
    Ipv4PrimaryDNS: '10.1.1.1',
    Ipv4SecondaryDNS: '10.1.1.2',
    Ipv4SubnetMask: '255.255.255.0',
    UrlBootFile: 'http://www.urlbootfile.iso',
    ServiceName: 'iLO Admin',
    ServiceEmail: 'admin@domain.com'
  )
end
