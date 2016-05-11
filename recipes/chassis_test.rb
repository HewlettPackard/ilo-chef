ilo =
{
    host: '16.85.179.65',
    user: 'Admin',
    password: 'admin123',
    ssl_enabled: false
}

iLO_chassis 'dump power_metrics' do
  ilos [ilo]
  power_metrics_file "#{Chef::Config[:file_cache_path]}/power_metrics.txt"
  action :dump
end

iLO_chassis 'dump thermal_metrics' do
  ilos [ilo]
  thermal_metrics_file "#{Chef::Config[:file_cache_path]}/thermal_metrics.txt"
  action :dump
end

iLO_chassis 'dump power_metrics AND thermal_metrics' do
  ilos [ilo]
  power_metrics_file "#{Chef::Config[:file_cache_path]}/power_metrics.txt"
  thermal_metrics_file "#{Chef::Config[:file_cache_path]}/thermal_metrics.txt"
  action :dump
end
