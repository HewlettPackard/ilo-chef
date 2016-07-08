ilo =
  {
    host: '16.85.179.199',
    user: 'Admin',
    password: 'admin123',
    ssl_enabled: false
  }

ilo_service_root 'dump schema and registry' do
  ilos [ilo]
  schema_file "#{Chef::Config[:file_cache_path]}/schema.txt"
  schema_prefix 'Account'
  registry_file "#{Chef::Config[:file_cache_path]}/registry.txt"
  registry_prefix 'Base'
  action :dump
end
