ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_boot_settings 'dump boot settings' do
  ilos [ilo]
  dump_file "#{Chef::Config[:file_cache_path]}/boot_settings_dump.txt"
  action :dump
end
