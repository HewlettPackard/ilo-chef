ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_boot_settings 'revert boot settings' do
  ilos [ilo]
  action :revert
end
