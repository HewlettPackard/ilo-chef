ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_manager_network_protocol 'set timeout' do
  ilos [ilo]
  timeout 60
  action :set
end
