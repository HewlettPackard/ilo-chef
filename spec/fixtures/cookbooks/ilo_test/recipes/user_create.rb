ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_user 'create user' do
  ilos [ilo]
  username 'test1'
  password 'password'
  login_priv true
  remote_console_priv true
  user_config_priv true
  virtual_media_priv true
  virtual_power_and_reset_priv true
  ilo_config_priv true
  action :create
end
