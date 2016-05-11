ilo =
{
    host: '16.85.179.65',
    user: 'Admin',
    password: 'admin123',
    ssl_enabled: false
}

iLO_manager_network_protocol 'Set the timeout' do
  ilos [ilo]
  timeout 60
  action :set
end

iLO_manager_network_protocol 'Set the timeout' do
  ilos [ilo]
  timeout 30
  action :set
end
