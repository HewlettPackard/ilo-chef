ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_user 'delete user' do
  ilos [ilo]
  username 'test1'
  action :delete
end
