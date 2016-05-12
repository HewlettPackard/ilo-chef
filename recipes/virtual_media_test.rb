ilo =
{
    host: '16.85.179.65',
    user: 'Admin',
    password: 'admin123',
    ssl_enabled: false
}

iLO_virtual_media 'insert virtual media' do
  ilos [ilo]
  iso_uri 'http://10.254.224.38:5000/ubuntu-15.04-desktop-amd64.iso'
  action :insert
end

iLO_virtual_media 'eject virtual media' do
  ilos [ilo]
  action :eject
end
