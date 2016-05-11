ilo =
{
    host: '16.85.179.65',
    user: 'Admin',
    password: 'admin123',
    ssl_enabled: false
}

iLO_computer_details 'dump computer details' do
  ilos [ilo]
  data_bag 'computer_details_bag'
  dump_file "#{Chef::Config[:file_cache_path]}/computer_details.txt"
  action :dump
end
