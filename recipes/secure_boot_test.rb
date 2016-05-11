ilo =
{
    host: '16.85.179.65',
    user: 'Admin',
    password: 'admin123',
    ssl_enabled: false
}

iLO_secure_boot 'enable secure boot' do
  ilos [ilo]
  enable true
  action :secure_boot
end

iLO_secure_boot 'disable secure boot' do
  ilos [ilo]
  enable false
  action :secure_boot
end
