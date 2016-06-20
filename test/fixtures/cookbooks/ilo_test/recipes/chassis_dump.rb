ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_chassis 'dump chassis metrics' do
  ilos [ilo]
  power_metrics_file "#{Chef::Config[:file_cache_path]}/power_metrics.txt"
  thermal_metrics_file "#{Chef::Config[:file_cache_path]}/thermal_metrics.txt"
  action :dump
end
