ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_account_service 'change test account password' do
  ilos [ilo]
  username 'test'
  password 'newtest123'
  action :changePassword
end
