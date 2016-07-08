ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_log_entry 'dump log entries' do
  ilos [ilo]
  log_type 'IEL'
  severity_level 'OK'
  dump_file "#{Chef::Config[:file_cache_path]}/IEL_dump.txt"
  action :dump
end
