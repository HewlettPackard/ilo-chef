ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_log_entry 'clear log entries' do
  ilos [ilo]
  log_type 'IEL'
  action :clear
end
