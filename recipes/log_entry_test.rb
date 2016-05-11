ilo =
{
    host: '16.85.179.65',
    user: 'Admin',
    password: 'admin123',
    ssl_enabled: false
}

iLO_log_entry 'dump log entries' do
  ilos [ilo]
  log_type "IEL"
  severity_level "OK"
  dump_file "#{Chef::Config[:file_cache_path]}/IEL_dump.txt"
  action :dump
end

iLO_log_entry 'clear log entries' do
  ilos [ilo]
  log_type "IEL"
  action :clear
end
