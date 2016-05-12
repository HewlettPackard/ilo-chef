ilo =
{
    host: '16.85.179.65',
    user: 'Admin',
    password: 'admin123',
    ssl_enabled: false
}

iLO_service_root 'dump schema' do
  ilos [ilo]
  schema_file "#{Chef::Config[:file_cache_path]}/schema.txt"
  schema_prefix "Account"
  action :dump
end

iLO_service_root 'dump registry' do
  ilos [ilo]
  registry_file "#{Chef::Config[:file_cache_path]}/registry.txt"
  registry_prefix "Base"
  action :dump
end

iLO_service_root 'dump schema and registry' do
  ilos [ilo]
  schema_file "#{Chef::Config[:file_cache_path]}/schema.txt"
  schema_prefix "Account"
  registry_file "#{Chef::Config[:file_cache_path]}/registry.txt"
  registry_prefix "Base"
  action :dump
end
