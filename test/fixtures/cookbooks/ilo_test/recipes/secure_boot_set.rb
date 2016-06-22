ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_secure_boot 'enable secure boot' do
  ilos [ilo]
  enable true
  action :set
end
