ilo =
{
    host: '16.85.179.65',
    user: 'Admin',
    password: 'admin123',
    ssl_enabled: false
}

iLO_firmware_update 'change firmware' do
  ilos [ilo]
  fw_version 2.51
  fw_uri 'wwww.notarealuri.com'
  action :upgrade
end

iLO_firmware_update 'set firmware back' do
  ilos [ilo]
  fw_version 2.50
  fw_uri ''
  action :upgrade
end
