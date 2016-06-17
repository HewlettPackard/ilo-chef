ilo =
  {
    host: '16.85.179.199',
    user: 'Admin',
    password: 'admin123',
    ssl_enabled: false
  }
  
ilo_account_service 'delete test account' do
  ilos [ilo]
  username 'test'
  action :delete
end
