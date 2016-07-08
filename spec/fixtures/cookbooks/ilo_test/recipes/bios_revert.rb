ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_bios 'revert bios' do
  ilos [ilo]
  action :revert
end
