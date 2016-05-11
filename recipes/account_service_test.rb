ilo =
{
    host: '16.85.179.65',
    user: 'Admin',
    password: 'admin123',
    ssl_enabled: false
}

iLO_account_service "create test account" do
  ilos [ilo]
  username "test"
  password "test123456789"
  action :create
end

iLO_account_service "change test account password" do
  ilos [ilo]
  username "test"
  password "newtest123456789"
  action :create
end

iLO_account_service "delete test account" do
  ilos [ilo]
  username "test"
  action :delete
end
