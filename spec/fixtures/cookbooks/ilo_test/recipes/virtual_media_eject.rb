ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_virtual_media 'eject virtual media' do
  ilos [ilo]
  action :eject
end
