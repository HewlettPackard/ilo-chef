ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_virtual_media 'insert virtual media' do
  ilos [ilo]
  iso_uri 'http://1.1.1.1:5000/ubuntu-15.04-desktop-amd64.iso'
  action :insert
end
