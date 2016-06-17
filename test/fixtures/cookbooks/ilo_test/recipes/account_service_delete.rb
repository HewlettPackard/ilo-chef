ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_account_service 'delete test account' do
  ilos [ilo]
  username 'test'
  action :delete
end
