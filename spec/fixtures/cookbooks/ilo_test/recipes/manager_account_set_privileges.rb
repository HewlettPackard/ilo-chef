ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_manager_account 'set privileges' do
  ilos [ilo]
  username 'test'
  login_priv true
  remote_console_priv true
  user_config_priv true
  virtual_media_priv true
  virtual_power_and_reset_priv true
  ilo_config_priv true
  action :set_privileges
end
