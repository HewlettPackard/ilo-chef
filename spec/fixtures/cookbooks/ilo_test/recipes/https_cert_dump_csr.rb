ilo1 =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_https_cert 'dump csr' do
  ilo ilo1
  my_file '/c/example_file'
  action :dump_csr
end
