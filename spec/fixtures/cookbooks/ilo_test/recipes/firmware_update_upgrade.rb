ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_firmware_update 'upgrade firmware' do
  ilos [ilo]
  fw_version 2.51
  fw_uri 'www.firmwareURI.com'
  action :upgrade
end
