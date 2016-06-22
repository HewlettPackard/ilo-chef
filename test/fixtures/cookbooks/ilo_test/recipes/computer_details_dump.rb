ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_computer_details 'dump computer details' do
  ilos [ilo]
  data_bag 'computer_details_bag'
  dump_file "#{Chef::Config[:file_cache_path]}/computer_details.txt"
  action :dump
end
