ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_power 'power on' do
  ilos [ilo]
  action :poweron
end
