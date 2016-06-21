ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_power 'power off' do
  ilos [ilo]
  action :poweroff
end
