ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_account_service 'create test account' do
  ilos [ilo]
  username 'test'
  password 'test123'
  action :create
end
