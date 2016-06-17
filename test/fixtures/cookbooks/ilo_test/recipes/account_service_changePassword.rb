ilo =
  {
    host: '16.85.179.199',
    user: 'Admin',
    password: 'admin123',
    ssl_enabled: false
  }

ilo_account_service 'change test account password' do
  ilos [ilo]
  username 'test'
  password 'newtest123'
  action :changePassword
end
