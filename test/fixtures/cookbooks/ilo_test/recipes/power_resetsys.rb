ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_power 'reset sys' do
  ilos [ilo]
  action :resetsys
end
