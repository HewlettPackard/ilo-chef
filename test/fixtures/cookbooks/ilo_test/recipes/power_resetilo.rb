ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_power 'reset ilo' do
  ilos [ilo]
  action :resetilo
end
