ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_service_root 'dump schema and registry' do
  ilos [ilo]
  schema_file "#{Chef::Config[:file_cache_path]}/schema.txt"
  schema_prefix 'Account'
  registry_file "#{Chef::Config[:file_cache_path]}/registry.txt"
  registry_prefix 'Base'
  action :dump
end
